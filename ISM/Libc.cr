#Libc functions to deal with SUID and SGID bit
lib LibC
    fun seteuid(uid : UidT): Int
    fun setegid(uid : UidT): Int
    fun getegid : UidT
    fun geteuid : UidT
end
