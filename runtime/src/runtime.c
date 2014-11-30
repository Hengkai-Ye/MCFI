#include <def.h>
#include <syscall.h>
#include <mm.h>
#include <io.h>
#include <string.h>
#include <tcb.h>

static void* prog_brk;

void set_tcb(unsigned long sb_tcb) {
  if (sb_tcb > FourGB) {
    report_error("[set_tcb] sandbox tcb is out of sandbox\n");
  }

  TCB* tcb = thread_self();
  tcb->tcb_inside_sandbox = (void*)sb_tcb;
}

void rock_patch(unsigned long patchpoint) {
}

void *rock_mmap(void *start, size_t len, int prot, int flags, int fd, off_t off) {
  if ((unsigned long) start > FourGB || len > FourGB) {
    // report error
    quit(-1);
  }
  return mmap(start, len, prot, flags | MAP_32BIT, fd, off);
}

int rock_mprotect(void *addr, size_t len, int prot) {
  return mprotect(addr, len, prot);
}

int rock_munmap(void *start, size_t len) {
  return munmap(start, len);
}

void *rock_mremap(void *old_addr, size_t old_len, size_t new_len,
                  int flags, void* new_addr) {
  return mremap(old_addr, old_len, new_len, flags, new_addr);
}

void* rock_brk(void* newbrk) {
  return 0;
}

void load_native_code(const char* code_file_name) {
}

void unload_native_code(const char* code_file_name) {
}

void rock_clone(void) {
}

void rock_execve(void) {
}

void rock_shmat(void) {
}

void rock_shmdt(void) {
}