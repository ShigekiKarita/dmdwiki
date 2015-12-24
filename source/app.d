import wiki.recent;

import vibe.appmain;
import vibe.http.fileserver;
import vibe.http.router;
import vibe.http.server;

void toIndex(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
    res.redirect("/index.html");
}

immutable recentMD = "./public/recent.md";
immutable articles = "./public/articles";
auto recentArticles = "";
void toRecent(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
    import std.file;
    import vibe.core.log;
    recentArticles = "# Recent changes\n" ~ dirToMarkdown(articles);
    logInfo(recentArticles);
    recentMD.write(recentArticles);
    res.redirect("/index.html#!recent.md");
}


immutable searchMD = "./public/search.md";
immutable searchForm = q{
<form action="search" method="post">
  <input type="text" name="example">
  <input type="submit" value="submit">
</form>
};

void toSearch(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
    // TODO: put text-form and POST query
    import std.file;
    searchMD.write(searchForm);
    res.redirect("/index.html#!search.md");
}

shared static this()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    auto router = new URLRouter;
    router.get("/", &toIndex);
    router.get("/recent", &toRecent);
    router.get("/search", &toSearch);
    router.get("*", serveStaticFiles("./public/",));

    listenHTTP(settings, router);
}
