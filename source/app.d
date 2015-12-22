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
    import wiki;
    import std.file;
    import vibe.core.log;
    recentArticles = createRecentLists(articles);
    logInfo(recentArticles);
    recentMD.write(recentArticles);
    res.redirect("/index.html#!recent.md");
}

shared static this()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    auto router = new URLRouter;
    router.get("/", &toIndex);
    router.get("/index.html#!recent.md", &toRecent);
    router.get("/recent", &toRecent);
    router.get("*", serveStaticFiles("./public/",));

    listenHTTP(settings, router);
}
