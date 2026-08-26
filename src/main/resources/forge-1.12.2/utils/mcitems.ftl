<#function mappedBlockToBlockStateCode mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlockStateCode(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlockStateCode(outputs?keep_after("/*@:*/")) + ")">
    <#elseif !hasMetadata(mappedBlock)>
        <#return mappedBlockToBlock(mappedBlock) + ".getDefaultState()">
    <#else>
        <#return mappedBlockToBlock(mappedBlock) + ".getStateFromMeta(" + getMappedMCItemMetadata(mappedBlock) + ")">
    </#if>
</#function>

<#function mappedBlockToBlock mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","") + ".getBlock()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlock(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlock(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return mappedElementToRegistryEntry(mappedBlock)>
    <#else>
        <#return mappedBlock.toString().split("#")[0]>
    </#if>
</#function>

<#function mappedMCItemToItemStackCode mappedBlock amount=1>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItemStackCode(outputs?keep_before("/*@:*/"), amount)
            + ":" + mappedMCItemToItemStackCode(outputs?keep_after("/*@:*/"), amount) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return toItemStack(mappedElementToRegistryEntry(mappedBlock), amount)>
    <#else>
        <#return toItemStack(mappedBlock, amount, hasMetadata(mappedBlock))>
    </#if>
</#function>

<#function toItemStack item amount hasMetadata=false>
    <#if !hasMetadata>
        <#if amount == 1>
            <#return "new ItemStack(" + item + ")">
        <#else>
            <#return "new ItemStack(" + item + "," + (amount == amount?floor)?then(amount + ")","(int)(" + amount + "))")>
        </#if>
    <#else>
        <#return "new ItemStack(" + item.toString().split("#")[0] + "," + (amount == amount?floor)?then(amount + ",","(int)(" + amount + "),") + getMappedMCItemMetadata(item) + ")">
    </#if>
</#function>

<#function mappedMCItemToItem mappedBlock>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "") + ".getItem()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItem(outputs?keep_before("/*@:*/"))
            + ":" + mappedMCItemToItem(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return generator.isBlock(mappedBlock)?then("Item.getItemFromBlock(", "") + mappedElementToRegistryEntry(mappedBlock) + generator.isBlock(mappedBlock)?then(")", "")>
    <#else>
        <#return mappedBlock?contains("Blocks.")?then("Item.getItemFromBlock(", "") + mappedBlock.toString().split("#")[0] + mappedBlock?contains("Blocks.")?then(")","")>
    </#if>
</#function>

<#function mappedMCItemToIngredient mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "new OreIngredient(new ResourceLocation(\"" + mappedBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":") + "\"))">
    <#elseif mappedBlock.getMappedValue(1).startsWith("#")>
        <#return "new OreIngredient(new ResourceLocation(\"" + mappedBlock.getMappedValue(1).replace("#", "") + "\"))">
    <#else>
        <#return "Ingredient.fromStacks(" + mappedMCItemToItemStackCode(mappedBlock, 1) + ")">
    </#if>
</#function>

<#function mappedMCItemsToIngredient mappedBlocks=[]>
    <#if !mappedBlocks??>
        <#return "Ingredient.EMPTY">
    <#elseif mappedBlocks?size == 1>
        <#return mappedMCItemToIngredient(mappedBlocks?first)>
    <#else>
        <#assign itemsOnly = true>

        <#list mappedBlocks as mappedBlock>
            <#if mappedBlock.getUnmappedValue().startsWith("TAG:") || mappedBlock.getMappedValue(1).startsWith("#")>
                <#assign itemsOnly = false>
                <#break>
            </#if>
        </#list>

        <#if itemsOnly>
            <#assign retval = "Ingredient.fromStacks(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToItemStackCode(mappedBlock, 1)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + ")">
        <#else>
            <#assign retval = "Ingredient.merge(Arrays.asList(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToIngredient(mappedBlock)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + "))">
        </#if>
    </#if>
</#function>

<#function containsAnyOfBlocks elements blockToCheck>
    <#assign blocks = []>
    <#assign tags = []>
    <#assign retval = "">

    <#list elements as block>
        <#if block.getUnmappedValue().startsWith("TAG:")>
            <#assign tags += [block.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":")]>
        <#elseif block.getMappedValue(1).startsWith("#")>
            <#assign tags += [block.getMappedValue(1).replace("#", "")]>
        <#else>
            <#assign blocks += [mappedBlockToBlock(block)]>
        </#if>
    </#list>

    <#if !blocks?has_content && !tags?has_content>
        <#return "false">
    <#elseif blocks?has_content>
    	<#assign retval += "Arrays.asList(">
        <#list blocks as block>
        	<#assign retval += block>
			<#if block?has_next><#assign retval += ","></#if>
        </#list>
        <#assign retval += ").contains("+ blockToCheck + ".getBlock())">

        <#if tags?has_content>
        	<#assign retval += "||">
        </#if>
    </#if>

    <#if tags?has_content>
    	<#assign retval += "Stream.of(">
        <#list tags as tag>
        	<#assign retval += "BlockTags.getCollection().getOrCreate(new ResourceLocation(\"" + tag + "\"))">
            <#if tag?has_next><#assign retval += ","></#if>
        </#list>
        <#assign retval += ").anyMatch(" + blockToCheck + "::isIn)">
    </#if>

    <#return retval>
</#function>

<#function mappedElementToRegistryEntry mappedElement>
    <#return JavaModName + generator.isBlock(mappedElement)?then("Blocks", "Items") + "."
    + generator.getRegistryNameFromFullName(mappedElement)?upper_case + transformExtension(mappedElement)?upper_case>
</#function>

<#function transformExtension mappedBlock>
    <#assign extension = mappedBlock?keep_after_last(".")?replace("body", "chestplate")?replace("legs", "leggings")>
    <#return (extension?has_content)?then("_" + extension, "")>
</#function>

<#function mappedMCItemToItemObjectJSON mappedBlock itemKey="item">
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameFromFullName(mappedBlock.getUnmappedValue())!""/>
        <#if customelement?has_content>
            <#return "\"" + itemKey + "\": \"" + "${modid}:" + customelement
            + transformExtension(mappedBlock)
            + "\"">
        <#else>
            <#return "\"" + itemKey + "\": \"minecraft:air\"">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "\"type\": \"forge:ore_dict\", \"ore\": \"" + mappedBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":")?lower_case + "\"">
    <#else>
        <#assign mapped = mappedBlock.getMappedValue(1) />
        <#if mapped.startsWith("#")>
            <#return "\"type\": \"forge:ore_dict\", \"ore\": \"" + mapped.replace("#", "") + "\"">
        <#elseif mapped.contains(":")>
            <#return "\"" + itemKey + "\": \"" + mapped + "\"">
        <#else>
            <#return "\"" + itemKey + "\": \"minecraft:" + mapped + "\"">
        </#if>
    </#if>
</#function>

<#function mappedMCItemToRegistryName mappedBlock acceptTags=false>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameFromFullName(mappedBlock.getUnmappedValue())!""/>
        <#if customelement?has_content>
            <#return "${modid}:" + customelement + transformExtension(mappedBlock)>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#if acceptTags>
            <#return "#" + mappedBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":")?lower_case>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#else>
        <#assign mapped = mappedBlock.getMappedValue(1) />
        <#if mapped.startsWith("#")>
            <#if acceptTags>
                <#return mapped>
            <#else>
                <#return "minecraft:air">
            </#if>
        <#elseif mapped.contains(":")>
            <#return mapped>
        <#else>
            <#return "minecraft:" + mapped>
        </#if>
    </#if>
</#function>

<#function hasMetadata mappedBlock>
    <#return mappedBlock.toString().contains("#")>
</#function>

<#function getMappedMCItemMetadata mappedBlock>
    <#return mappedBlock.toString().split("#")[1]>
</#function>