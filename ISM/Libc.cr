#Libc functions to deal with SUID and SGID bit
lib LibC
    fun seteuid(uid : UidT): Int
    fun setegid(uid : UidT): Int
    fun setgid(uid : UidT): Int
    fun getgid : UidT
    fun getegid : UidT
    fun geteuid : UidT
end
