<#if field$vector_opcodes == "multiply">
<@addTemplate file="utils/vector_mul.java.ftl"/>
(vectorMul(${input$vector1}, ${input$vector2}))
<#else>
(${input$vector1}.${field$vector_opcodes}(${input$vector2}))
</#if>