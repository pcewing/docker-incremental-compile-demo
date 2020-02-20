#include <iostream>

#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

int main(int argc, char* argv[]) {
    uid_t uid = getuid();

    struct passwd *p = getpwuid(uid);

    if (p == nullptr) {
        std::cerr << "No user with id " << uid << " found." << std::endl;
        return 1;
    }

    std::cout << "Hello from " << p->pw_name << "!" << std::endl;
    return 0;
}

