@Styx = {
  Initializers: {}
}

@Styx.URL =
  go: (url, force=false) ->
    # 'Force' required if you want to reload same page with another anchor
    url = this.build(url, "reloadthispagepls=#{Math.random()}") if force
    window.location.href = url

  build: (url, params) ->
    hash = url.match(/\#.*$/)
    hash = if hash then hash[0] else false

    url = url.replace(hash, '') if hash
    url = url + "?" if url.indexOf("?") == -1

    url = "#{url}&#{params}"

    url = url + hash if hash

    return url