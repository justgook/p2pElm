// based on https://medium.com/slack-developer-blog/everything-you-ever-wanted-to-know-about-unfurling-but-were-afraid-to-ask-or-how-to-make-your-e64b4bb9254
interface FacebookMeta {
  type: string
  url: string
  title: string
  description: string
  image: string
  image_width: number
  image_height: number
}
interface Twitter {
  card: string
  domain: string
  title: string
  description: string
  image: string
  url: string
  label1: string
  data1: string
  label2: string
  data2: string
}

interface Options {
  facebook?: FacebookMeta
  twitter?: Twitter
}

module.exports = class MetaPlugin {
  content = ""
  constructor({ facebook, twitter }: Options) {
    let result = []
    if (facebook) {
      const { type, url, title, description, image, image_width, image_height } = facebook
      if (type) result.push(`<meta property="og:type" content="${type}" />`)
      if (url) result.push(`<meta property="og:url" content="${url}" />`)
      if (title) result.push(`<meta property="og:title" content="${title}" />`)
      if (description) result.push(`<meta property="og:description" content="${description}" />`)
      if (image) result.push(`<meta property="og:image" content="${image}" />`)
      if (image_width) result.push(`<meta property="og:image:width" content="${image_width}" />`)
      if (image_height) result.push(`<meta property="og:image:height" content="${image_height}" />`)
    }
    if (twitter) {
      const { card, domain, title, description, image, url, label1, data1, label2, data2 } = twitter
      if (card) result.push(`<meta name="twitter:card" content="${card}" />`)
      if (domain) result.push(`<meta name="twitter:domain" value="${domain}" />`)
      if (title) result.push(`<meta name="twitter:title" value="${title}" />`)
      if (description) result.push(`<meta name="twitter:description" value="${description}" />`)
      if (image) result.push(`<meta name="twitter:image" content="${image}" />`)
      if (url) result.push(`<meta name="twitter:url" value="${url}" />`)
      if (label1) result.push(`<meta name="twitter:label1" value="${label1}" />`)
      if (data1) result.push(`<meta name="twitter:data1" value="${data1}" />`)
      if (label2) result.push(`<meta name="twitter:label2" value="${label2}" />`)
      if (data2) result.push(`<meta name="twitter:data2" value="${data2}" />`)
    }
    this.content = result.join("")
  }
  apply(compiler: any) {
    compiler.plugin('compilation', (compilation: any) => {
      compilation.plugin('html-webpack-plugin-before-html-processing', (htmlPluginData: any, callback: any) => {
        if (this.content !== "") {
          console.log("html-webpack-plugin-before-html-processing of MetaPlugin")
          console.log(this.content)
          htmlPluginData.html = htmlPluginData.html.replace(
            /(<\/head>)/i, this.content + '$&');
        }
        callback(null, htmlPluginData);
      });
    });

  };
}

