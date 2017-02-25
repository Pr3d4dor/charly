const fs_open = __internal__method("fs_open")
const fs_close = __internal__method("fs_close")
const fs_stat = __internal__method("fs_stat")
const fs_lstat = __internal__method("fs_lstat")
const fs_gets = __internal__method("fs_gets")
const fs_exists = __internal__method("fs_exists")
const fs_print = __internal__method("fs_print")

class File {
  static property LINE_SEPARATOR

  property fd
  property filename
  property mode
  property encoding

  /**
   * Opens *name* with *mode* in *encoding*
   **/
  static func open(name, mode, encoding) {
    const fd = fs_open(name, mode, encoding)
    const file = File(fd, name, mode, encoding)
    return file
  }

  /**
   * Returns the complete content of *name*
   **/
  static func read(name, encoding) {
    const file = @open(name, "r", encoding)

    const lines = []
    let tmp

    while tmp = file.gets() {
      lines.push(tmp)
    }

    return lines.join(@LINE_SEPARATOR)
  }

  /**
   * Returns a stat object for *filename*
   **/
  static func stat(filename) {
    fs_stat(filename)
  }

  /**
   * Returns a lstat object for *filename*
   **/
  static func lstat(filename) {
    fs_lstat(filename)
  }

  func constructor(fd, filename, mode, encoding) {
    @fd = fd
    @filename = filename
    @mode = mode
    @encoding = encoding
  }

  /**
   * Read a line from the underlying file descriptor
   *
   * Returns null if nothing could be read
   **/
  func gets() {
    @check_open()
    fs_gets(@fd)
  }

  /**
   * Writes *data* into the underlying file descriptor
   **/
  func print(data) {
    @check_open()
    fs_print(@fd, data.to_s())
  }

  /**
   * Closes the underlying file descriptor
   **/
  func close() {
    @check_open()
    fs_close(@fd)
  }

  /**
   * Checks if the underlying file descriptor is still open
   **/
  func check_open() {
    const exists = fs_exists(@fd)

    unless exists {
      throw Exception("Can't perform action on closed file descriptor " + @fd)
    }
  }

}

File.LINE_SEPARATOR = "\n"

export = File