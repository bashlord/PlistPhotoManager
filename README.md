# PlistPhotoManager

Made a plist filesystem for images that I wanted cached, but with a little more control over how it was stored (utilizing the NSDictionary native style of iOS because, well it's there) The UI is there just so users can tinker around with it and see how the backend works with the frontend (and I guess i got a bit carried away being OCD)

The main part I wanted to showcase was the file in SysUtil.  PlistManager reads and writes to exising mutable plists, whilst FileSystem manager acts as a... file system manager that can read and write raw data to directories.  I had a project that needed text pairing to images, and other open source libs had caching but it got hectic/confounding to have to make/query multiple calls for textstrings as well.  Now, photos are written/read from an image directory, and the plist contains keys which are the string pathnames to where the raw data images are stored.  The value of the key (which is also a path, don't forget) contains any and all vals that were paired with the image (written as a NSDictionary).  The syncing of FileSystemManager and PListManager comes with CreatedPhotosManager, which starts off iterating through the plist, calling the keypathnames, and creating an array of the resulting paired images/string/ints/etc

I'd like to emphasize that I had architected the manager to act as such, but a few tweaks here and there can be made in PListManager since plists can store arrays and other data types.

Demo vid
https://www.youtube.com/watch?v=ikyLJvp1nz8&feature=youtu.be
