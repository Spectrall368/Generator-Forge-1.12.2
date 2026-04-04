{
    "parent": "block/${var_model}",
    "textures": {
      <#if data.particleTexture?has_content>"particle": "${data.particleTexture.format("%s:blocks/%s")}",</#if>
      "${var_txname}": "${data.texture.format("%s:blocks/%s")}",
      "${var_txname_top}": "${data.textureTop().format("%s:blocks/%s")}"
    }
}