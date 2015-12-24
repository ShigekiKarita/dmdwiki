module wiki.recent;

/// recent
import std.array : array;
import std.path : baseName, extension;
import std.file : dirEntries, SpanMode, isFile, isDir;
import std.algorithm : filter, sort, map, reduce;
import std.string : split, startsWith;

auto removeFirstDir(string path)
{
    immutable i = path.startsWith("./", "/") ? 2 : 1;
    return path
        .split("/")[i..$]
        .reduce!((a, b) => a ~ "/" ~ b);
}

unittest
{
    assert("./hoge/fuga/foo".removeFirstDir == "fuga/foo");
    assert("hoge/fuga/foo".removeFirstDir == "fuga/foo");
    assert("/hoge/fuga/foo".removeFirstDir == "fuga/foo");
}

auto linkFormat(R)(R a, bool removeFirstDir = true)
{
    auto link = removeFirstDir ? a.removeFirstDir : a;
    return
        "[" ~ a.timeLastModified.toString ~ " :: " ~ a.baseName ~ "]"
        ~
        "(" ~ link ~ ")";
}

auto listdir(string pathname)
    in { assert(pathname.isDir); }
body {
    return dirEntries(pathname, SpanMode.shallow)
        .filter!isFile
        .filter!(f => f.extension == ".md")
        .array
        .sort!"a.timeLastModified.toUnixTime > b.timeLastModified.toUnixTime";
}

auto markdownList(Fs)(Fs files) {
    return "".reduce!"a ~ \"\n+ \" ~ b"(files) ~ "\n";
}

auto dirToMarkdown(string dir)
{
    auto ps = dir.listdir.map!linkFormat;
    return markdownList(ps);
}

unittest
{
    import std.file;
    alias F = std.file;

    auto dir = F.tempDir() ~ "/dmdwiki/listup/";
    auto a = dir ~ "a.md";
    auto b = dir ~ "b.md";
    auto c = dir ~ "c.md";

    F.mkdirRecurse(dir);

    synchronized // too bad...
    {
        import core.thread;
        F.append(a, "a");
        Thread.sleep( dur!("msecs")( 1000 ) );
        F.append(c, "c");
        Thread.sleep( dur!("msecs")( 1000 ) );
        F.append(b, "b");
    }

    assert(dir.listdir.array == [b, c, a]);
}
