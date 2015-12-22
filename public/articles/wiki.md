# Wiki

## how to write markdown

[http://dynalon.github.io/mdwiki/#!quickstart.md](http://dynalon.github.io/mdwiki/#!quickstart.md)

## how to publish wiki

put markdown files into `/home/wiki/public/articles`.
note that a root of internal links in `.md` is `/home/wiki/public`.

## Dependencies

---

### MDwiki

MDwiki is a CMS/Wiki completely built in HTML5/Javascript and runs 100% on the client.
(**BUT we extend something dynamicaly with [vibe.d](wiki.md#vibe.d) on the server**)

[http://dynalon.github.io/mdwiki/](http://dynalon.github.io/mdwiki/)

[http://www.catch.jp/wiki/index.php?MDwiki](http://www.catch.jp/wiki/index.php?MDwiki)


### vibe.d

This site is hosted on D web framework.
Vibe.d dynamic pages are as follows:

+ [`/recent`](/recent) : sorting recently modified articles
+ [`/search`](/search) : **(wip)** searching words in articles
+ [`/post`](/post)     : **(wip)** posting articles

for more info, visit [wiki-devel.md](wiki-devel.md)
