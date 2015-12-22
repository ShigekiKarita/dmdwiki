module wiki;

import std.array : array;
import std.path : baseName;
import std.file : dirEntries, SpanMode, isFile;
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

auto linkFormat(R)(R a, bool removeFirstDir=false)
{
    auto link = removeFirstDir ? a.removeFirstDir : a;
    return
        "[" ~ a.timeLastModified.toString ~ " :: " ~ a.baseName ~ "]"
        ~
        "(" ~ link ~ ")";
}

auto listdir(string pathname, bool removeFirstDir=false)
{
    return dirEntries(pathname, SpanMode.shallow)
        .filter!isFile
        .array
        .sort!"a.timeLastModified > b.timeLastModified"
        .map!(a => linkFormat(a, removeFirstDir));
}

auto createRecentLists(string articlePath)
{
    return
        "# Recent changes\n\n" ~
        reduce!((a, b) => a ~ "\n+ " ~ b)("", articlePath.listdir(true)) ~
        "\n";
}

unittest
{
    import std.file;
    alias F = std.file;

    auto dir = F.tempDir() ~ "/listup/";
    auto a = dir ~ "a";
    auto b = dir ~ "b";
    // do not care if dir exists
    F.mkdirRecurse(dir);
    // touch
    F.append(a, null);
    F.append(b, null);
    // check only linked paths
    auto eb =  "(" ~ b ~ ")";
    auto ea =  "(" ~ a ~ ")";
    auto result = listdir(dir);
    assert(result[0][$-eb.length..$] == eb);
    assert(result[1][$-ea.length..$] == ea);
}
