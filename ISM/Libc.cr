#Libc functions to deal with SUID and SGID bit
lib LibC
    fun getgid : Int
    fun seteuid(gid : UidT) : Int
    fun setegid(gid : UidT) : Int
end
