lib LibC
    #uid and gid
    fun setuid(id : UidT): Int
    fun getuid : UidT
    fun setgid(id : UidT): Int
    fun getgid : UidT

    #euid and egid
    fun setegid(id : UidT): Int
    fun seteuid(id : UidT): Int
    fun getegid : UidT
    fun geteuid : UidT

    #resuid and resgid
    fun setresgid(realId : UidT, effectiveId : UidT, savedId : UidT): Int
    fun setresuid(realId : UidT, effectiveId : UidT, savedId : UidT): Int
    fun getresgid : UidT
    fun getresuid : UidT
end
