<#include "../mcitems.ftl">
<#function hasToolContext>
  <#return data.type == "Block" || data.type == "Fishing" || data.type == "Generic">
</#function>
{
  "type": "minecraft:${data.type?lower_case?replace(" ", "_")}",
  "pools": [
    <#list data.pools as pool>
        {
          "name": "pool_${pool_index}",
          <#if pool.minrolls == pool.maxrolls>
          "rolls": ${pool.minrolls},
          <#else>
          "rolls": {
            "min": ${pool.minrolls},
            "max": ${pool.maxrolls}
          },
          </#if>
          <#if pool.hasbonusrolls>
              <#if pool.minbonusrolls == pool.maxbonusrolls>
              "bonus_rolls": ${pool.minbonusrolls},
              <#else>
              "bonus_rolls": {
                "min": ${pool.minbonusrolls},
                "max": ${pool.maxbonusrolls}
              },
              </#if>
          </#if>
          "entries": [
            <#list pool.entries as entry>
              {
                <#assign item = mappedMCItemToIngameNameNoTags(entry.item)>
                <#if entry.item.isAir() || item == "minecraft:air">
                "type": "empty",
                <#else>
                "type": "${entry.type}",
                "name": "${item}",
                </#if>
                "weight": ${entry.weight},
                "functions": [
                  {
                    "function": "set_count",
                    "count": {
                      "min": ${entry.minCount},
                      "max": ${entry.maxCount}
                    }
                  }
                  <#if entry.minEnchantmentLevel != 0 || entry.maxEnchantmentLevel != 0>
                  ,{
                    "function": "enchant_with_levels",
                    "treasure": true,
                    "levels": {
                      "min": ${entry.minEnchantmentLevel},
                      "max": ${entry.maxEnchantmentLevel}
                    }
                  }
                  </#if>
                ]
              }
                <#if entry?has_next>,</#if>
            </#list>
          ]
        }<#if pool?has_next>,</#if>
    </#list>
  ]
}
