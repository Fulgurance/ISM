#Libc functions to deal with SUID and SGID bit
lib LibC
    fun getgid : UidT
    fun setgid(gid : UidT) : Int
end
