require 'formula'

class Gdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.4.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gdb/gdb-7.4.tar.bz2'
  md5 '95a9a8305fed4d30a30a6dc28ff9d060'

  depends_on 'readline'

  def patches
    # patch to fix a crash when calling `run` twice in one session.  It is
    # upstream in gdb 7.5 and should be removed at that point.
    # http://old.nabble.com/-Bug-gdb-13619--New%3A-Crash-when-running-binary-a-second-time-in-the-same-session-td33196464.html
    { :p0 => DATA }
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-python=/usr",
                          "--with-system-readline"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end

__END__
diff -c -r1.18 solib-darwin.c
*** gdb/solib-darwin.c	4 Jan 2012 08:17:11 -0000	1.18
--- gdb/solib-darwin.c	8 Feb 2012 09:15:49 -0000
***************
*** 456,461 ****
--- 456,467 ----
        error (_("`%s': not a shared-library: %s"),
          found_pathname, bfd_errmsg (bfd_get_error ()));
      }
+
+   /* Make sure that the filename is malloc'ed.  The current filename
+      for fat-binaries BFDs is a name that was generated by BFD, usually
+      a static string containing the name of the architecture.  */
+   res->filename = xstrdup (pathname);
+
    return res;
  }