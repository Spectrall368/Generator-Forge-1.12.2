<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">
package ${package}.item;

public abstract class ${name}Item extends ItemArmor {

	public ${name}Item(EntityEquipmentSlot type) {
		super(EnumHelper.addArmorMaterial("${registryname}" ,"${modid}:${data.armorTextureFile}", ${data.maxDamage}, new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} },
            ${data.enchantability}, <#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.equipSound}"))<#else>null</#if>, ${data.toughness}f), 0, type);
	}

	<#if data.repairItems?has_content>
	@Override public boolean getIsRepairable(ItemStack itemstack, ItemStack repairitem) {
		return ${mappedMCItemsToIngredient(data.repairItems)}.test(repairitem);
	}
	</#if>

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet() {
			super(EntityEquipmentSlot.HEAD);
            setUnlocalizedName("${modid}.${registryname}_helmet");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
		}

		<#if data.helmetModelName != "Default" && data.getHelmetModel()??>
		private ModelBiped armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public ModelBiped getArmorModel(EntityLivingBase living, ItemStack stack, EntityEquipmentSlot slot, ModelBiped defaultModel) {
		    if (armorModel == null) {
		        armorModel = new ModelBiped();
		        armorModel.bipedHead = new ${data.helmetModelName}().${data.helmetModelPart};
		        armorModel.bipedHeadwear = new ${data.helmetModelName}().${data.helmetModelPart};
		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		<@addSpecialInformation data.helmetSpecialInformation, "item." + modid + "." + registryname + "_helmet"/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EntityEquipmentSlot slot, String type) {
			<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
			return "${modid}:textures/entities/${data.helmetModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@hasGlow data.helmetGlowCondition/>

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate() {
			super(EntityEquipmentSlot.CHEST);
            setUnlocalizedName("${modid}.${registryname}_chestplate");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
		}

		<#if data.bodyModelName != "Default" && data.getBodyModel()??>
		private ModelBiped armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public ModelBiped getArmorModel(EntityLivingBase living, ItemStack stack, EntityEquipmentSlot slot, ModelBiped defaultModel) {
		    if (armorModel == null) {
		        armorModel = new ModelBiped();
		        armorModel.bipedBody = new ${data.bodyModelName}().${data.bodyModelPart};

		        <#if data.armsModelPartL?has_content>
		        armorModel.bipedLeftArm = new ${data.bodyModelName}().${data.armsModelPartL};
		        </#if>
		        <#if data.armsModelPartR?has_content>
		        armorModel.bipedRightArm = new ${data.bodyModelName}().${data.armsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bodySpecialInformation, "item." + modid + "." + registryname + "_chestplate"/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EntityEquipmentSlot slot, String type) {
			<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bodyModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@hasGlow data.bodyGlowCondition/>

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings() {
			super(EntityEquipmentSlot.LEGS);
            setUnlocalizedName("${modid}.${registryname}_leggings");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
		}

		<#if data.leggingsModelName != "Default" && data.getLeggingsModel()??>
		private ModelBiped armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public ModelBiped getArmorModel(EntityLivingBase living, ItemStack stack, EntityEquipmentSlot slot, ModelBiped defaultModel) {
		    if (armorModel == null) {
		        armorModel = new ModelBiped();

		        <#if data.leggingsModelPartL?has_content>
		        armorModel.bipedLeftLeg = new ${data.leggingsModelName}().${data.leggingsModelPartL};
		        </#if>
		        <#if data.leggingsModelPartR?has_content>
		        armorModel.bipedRightLeg = new ${data.leggingsModelName}().${data.leggingsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		<@addSpecialInformation data.leggingsSpecialInformation, "item." + modid + "." + registryname + "_leggings"/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EntityEquipmentSlot slot, String type) {
			<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.leggingsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_2.png";
			</#if>
		}

		<@hasGlow data.leggingsGlowCondition/>

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots() {
			super(EntityEquipmentSlot.FEET);
            setUnlocalizedName("${modid}.${registryname}_boots");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
		}

		<#if data.bootsModelName != "Default" && data.getBootsModel()??>
		private ModelBiped armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public ModelBiped getArmorModel(EntityLivingBase living, ItemStack stack, EntityEquipmentSlot slot, ModelBiped defaultModel) {
		    if (armorModel == null) {
		        armorModel = new ModelBiped();

		        <#if data.bootsModelPartL?has_content>
		        armorModel.bipedLeftLeg = new ${data.bootsModelName}().${data.bootsModelPartL};
		        </#if>
		        <#if data.bootsModelPartR?has_content>
		        armorModel.bipedRightLeg = new ${data.bootsModelName}().${data.bootsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bootsSpecialInformation, "item." + modid + "." + registryname + "_boots"/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EntityEquipmentSlot slot, String type) {
			<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bootsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@hasGlow data.bootsGlowCondition/>

		<@onArmorTick data.onBootsTick/>
	}
	</#if>
}
<#-- @formatter:on -->