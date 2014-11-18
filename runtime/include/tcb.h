/*
 * This files defines the Thread Control Block used by the trusted runtime
 * to track each thread outside of the sandbox.
 */

#ifndef TCB_H
#define TCB_H
#include <def.h>

#define STACK_SIZE 0x10000

struct Context {
  unsigned long rax;                 /* 0x00 */
  unsigned long rbx;                 /* 0x08 */
  unsigned long rcx;                 /* 0x10 */
  unsigned long rdx;                 /* 0x18 */
  unsigned long rdi;                 /* 0x20 */
  unsigned long rsi;                 /* 0x28 */
  unsigned long rbp;                 /* 0x30 */
  unsigned long rsp;                 /* 0x38 */
  unsigned long r8;                  /* 0x40 */
  unsigned long r9;                  /* 0x48 */
  unsigned long r10;                 /* 0x50 */
  unsigned long r11;                 /* 0x58 */
  unsigned long r12;                 /* 0x60 */
  unsigned long r13;                 /* 0x68 */
  unsigned long r14;                 /* 0x70 */
  unsigned long r15;                 /* 0x78 */
};

typedef struct TCB_t {
  /* this will be set to point the the tcb
     inside the sandbox. Access to this
     is through %fs:0
  */
  void*         tcb_inside_sandbox;  /* 0x0 */

  /* the address of this TCB */
  void*         self;                /* 0x8 */
  
  /* sandbox_escape records how many times a thread
     has escaped the sandbox
   */
  unsigned long sandbox_escape;      /* 0x10 */
  /* sleep */
  unsigned long sleep;               /* 0x18 */
  unsigned long retaddr;             /* 0x20 */

  /* stack canary according to the x64 ABI */
  unsigned long canary;              /* 0x28 */

  /* application context */
  struct Context user_ctx;           /* 0x30 */
} TCB;

static TCB* thread_self(void) {
  TCB *self;
  __asm__ __volatile__("movq %%fs:0x8,%0" : "=r" (self) );
  return self;
}

static unsigned long thread_escapes(void) {
  unsigned long numEscape;
  __asm__ __volatile__("movq %%fs:0x10,%0" : "=r" (numEscape));
  return numEscape;
}

static bool thread_sleep(void) {
  unsigned long sleep;
  __asm__ __volatile__("movb %%fs:0xb0,%0" : "=r" (sleep));
  return sleep;
}

TCB* alloc_tcb(void);

#endif