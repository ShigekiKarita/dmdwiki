module wiki.search;

import wiki.recent;
import std.file : readText;
import std.algorithm; // : find, count;
import std.range;
import std.stdio : writeln;
import std.typecons : tuple;
import std.array;
import std.string;
import std.conv : to;

auto countQuery(string expr)(string src, string query)
{
    immutable qs = query.split;
    return qs.map!(q => src.count(q)).reduce!expr;
}


auto countFiles(F)(string query, F[] files)
{
    return files
        .map!readText
        .map!(s => s.countQuery!"a * b"(query))
        .zip(files)
        .filter!"a[0] > 0";
}

auto searchFiles(F)(string query, F[] files)
{
    return countFiles(query, files)
        .map!"a[1]"
        .array;
}

auto searchDir(string query, string dir)
{
    // TODO: new or freq
    // TODO: rewrite with sequence :: Monad m => [m a] => m [a]
    return countFiles(query, listdir(dir).array)
        .map!(a => a[1].linkFormat ~ " (score: " ~ a[0].to!string ~ ")");
}

unittest
{
    import std.file;
    import std.stdio : writeln;
    alias F = std.file;

    auto dir = F.tempDir() ~ "/dmdwiki/search/";
    auto a = dir ~ "a.md";
    auto b = dir ~ "b.md";

    F.rmdirRecurse(dir);
    F.mkdirRecurse(dir);
    F.write(a, "\n\nfad\nsfg" ~ "hoge" ~ "gdgdf\n \n\t fuga\n\tfoo\n");
    F.write(b, "\t sdfngfdd\ns\nfg" ~ "goo" ~ "gdgdf\n \n\t\tfoo\nfoooo\n");

    assert(searchFiles("foo", [a, b]) == [a, b]);
    assert(searchFiles("hoge", [a, b]) == [a]);
    assert(searchFiles("goo foo", [a, b]) == [b]);
    assert(searchFiles("hoo foo", [a, b]) == []);

    // assert(searchDir("goo foo", dir) == [b]);
    searchDir("foo", dir).writeln;
}
