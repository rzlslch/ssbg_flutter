# ssbg_flutter

Rewrite of [ssbg][ssbg] on Flutter.

Electron's ssbg build is huge. And when I compared them to Flutter build is like heaven and earth. Like, around ~200MB vs ~20MB. Might as well re-write it. I mean, Flutter is easy, dart is like javascript with typed function (No, not typescript. It's slow), it's like writing react-native but easier and smaller build size, and a lot less headache.

[ssbg]: https://github.com/rzlslch/ssbg

## Liquid Syntax

My purpose is to imitate `jekyll` syntax, at least the one that I used on my blog, and that includes `tags`, `filters`, `variables` and so on. I'll list them below

### tags

Basically standart liquid syntax that supported by [dart's liquid engine][liquid_engine].  
Currently there's a custom `tag` called `post_url` that I really want to remove altogether, and it's still on progress. Just for backward compatibility with my documents. I want to preserve them as it is for now.

[liquid_engine]: https://pub.dev/documentation/liquid_engine/latest/

### filters

Same as `tags`, but with additional filter that I add myself. Currently:

- **date** "strftime format"

### variables

`jekyll`'s variables, that basically goes like this:

```javascript
site: {
    title: config.title,
    url: config.url,
    email: config.email
    posts: [
        {
            layout: post.layout,
            title: post.title,
            permalink: post.permalink,
            date: post.date,
            categories: post.categories,
            comments: post.comments,
            url: post.url,
            prev: post.prev, // basically post but the previous
            next: post.next, // same but next post
        },
        ...
    ]
},
page: { // this is the currently loaded doc
    layout: post.layout,
    title: post.title,
    permalink: post.permalink,
    date: post.date,
    categories: post.categories,
    comments: post.comments,
    url: post.url,
}
```

I want to add `categories` so that I can create dedicated page for listing `post` based on `category` and so on, but that's not the primary focus for now.

## Features

Expected feature that still on progress:

- [x] generate page
- [x] generate post
- [x] add post
- [x] add page
- [x] add include template
- [x] add layout template
- [ ] 404 resolver

There're still a lot of dream features that I want to implement, and I will list them here:

- [x] built in http server
  - [x] eeh.. kinda, but can't change build folder yet..
  - [x] change build folder and serve that folder instead
- [ ] input assets directly from the editor
- [ ] code editor with syntax highlighting
- [ ] settings. for example, create a template to generate a new post
- [ ] theme. including template, config, etc
- [ ] deploy to github/gitlab pages
