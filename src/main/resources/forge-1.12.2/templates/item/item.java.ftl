<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">
<#include "../mcitems.ftl">
<#include "../triggers.java.ftl">
package ${package}.item;
<#assign hasCustomJAVAModels = data.hasCustomJAVAModel() || data.getModels()?filter(e -> e.hasCustomJAVAModel())?has_content>

<@javacompress>
public class ${name}Item extends Item<#if data.hasBannerPatterns()>Banner<#elseif data.isMusicDisc>Record<#elseif data.isFood>Food</#if> {

	public ${name}Item() {
	    <#if data.isMusicDisc>super("${modid}.${registryname}", <#if data.musicDiscMusic.getUnmappedValue().startsWith("CUSTOM:")>new SoundEvent<#else>ForgeRegistries.SOUND_EVENTS.getValue</#if>(new ResourceLocation("${data.musicDiscMusic}")));<#elseif data.isFood>super(${data.nutritionalValue}, ${data.saturation}f, ${data.isMeat});</#if>
			setUnlocalizedName("${modid}.${registryname}");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
				<#if data.hasInventory()>
				setMaxStackSize(1);
				<#elseif data.damageCount != 0>
				setMaxStackSize(1);
				setMaxDamage(${data.damageCount});
				<#elseif data.stackSize != 64>
				setMaxStackSize(${data.stackSize});
				</#if>
				<#if data.isFood>
					<#if data.isAlwaysEdible>setAlwaysEdible();</#if>
				</#if>
				<#if data.stayInGridWhenCrafting && (!data.recipeRemainder?? || data.recipeRemainder.isEmpty()) && data.damageCount != 0>
				setNoRepair();
				</#if>
				<#if hasCustomJAVAModels>
				setTileEntityItemStackRenderer(new ${name}ItemRenderer());
	            </#if>
	}

    <#if data.rarity != "COMMON">
    @Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.rarity};
    }
    </#if>

	<#if data.hasBannerPatterns()> <#-- Workaround to allow both music disc and patterns info in description -->
	@Override public String getItemStackDisplayName(ItemStack stack) {
		return net.minecraft.util.text.translation.I18n.translateToLocal("item.${modid}.${registryname}.name.patterns");
	}
	</#if>

	<#if data.hasNonDefaultAnimation()>
	@Override public EnumAction getItemUseAction(ItemStack itemstack) {
		return EnumAction.${data.animation?upper_case};
	}
	</#if>

	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasContainerItem() {
			return true;
		}

		<#if data.recipeRemainder?? && !data.recipeRemainder.isEmpty()>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return ${mappedMCItemToItemStackCode(data.recipeRemainder, 1)};
			}
		<#elseif data.damageOnCrafting && data.damageCount != 0>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamage(itemstack.getDamage() + 1);
				if(retval.getDamage() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}
		<#else>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return new ItemStack(this);
			}
		</#if>
	</#if>

	<#if data.enchantability != 0>
	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}
	</#if>

	<#if (!data.isFood && data.useDuration != 0) || (data.isFood && data.useDuration != 32)>
	@Override public int getMaxItemUseDuration(ItemStack itemstack) {
		return ${data.useDuration};
	}
	</#if>

	<#if data.toolType != 1>
	@Override public float getDestroySpeed(ItemStack par1ItemStack, IBlockState par2Block) {
		return ${data.toolType}f;
	}
	</#if>

	<#if data.enableMeleeDamage>
		@Override public Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot equipmentSlot) {
			if (equipmentSlot == EntityEquipmentSlot.MAINHAND) {
				ImmutableMultimap.Builder<String, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.putAll(super.getItemAttributeModifiers(equipmentSlot));
				builder.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Item modifier", ${data.damageVsEntity - 1}d, 0));
				builder.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Item modifier", -2.4, 0));
				return builder.build();
			}
			return super.getItemAttributeModifiers(equipmentSlot);
		}
	</#if>

	<@hasGlow data.glowCondition/>

	<#if data.destroyAnyBlock>
	@Override public boolean canHarvestBlock(IBlockState state) {
		return true;
	}
	</#if>

	<@addSpecialInformation data.specialInformation, "item." + modid + "." + registryname/>

	<#assign shouldExplicitlyCallStartUsing = !data.isFood && (data.useDuration > 0)> <#-- ranged items handled in if below so no need to check for that here too -->
	<#if hasProcedure(data.onRightClickedInAir) || data.hasInventory() || data.enableRanged || shouldExplicitlyCallStartUsing>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, EntityPlayer entity, EnumHand hand) {
		<#if data.enableRanged>
		ActionResult<ItemStack> ar = new ActionResult(EnumActionResult.FAIL, entity.getHeldItem(hand));
		<#else>
		ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
		</#if>

		<#if data.enableRanged>
			<#if hasProcedure(data.rangedUseCondition)>
			if (<@procedureCode data.rangedUseCondition, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "world",
				"entity": "entity",
				"itemstack": "ar.getResult()"
			}, false/>)
			</#if>
			if (entity.capabilities.isCreativeMode || findAmmo(entity) != ItemStack.EMPTY) {
				ar = new ActionResult(EnumActionResult.SUCCESS, entity.getHeldItem(hand));
				entity.setActiveHand(hand);
			}
		<#elseif shouldExplicitlyCallStartUsing>
			entity.setActiveHand(hand);
		</#if>

		<#if data.hasInventory()>
		if(entity instanceof EntityPlayerMP) {
			NetworkHooks.openGui((EntityPlayerMP) entity, new INamedContainerProvider() {
				@Override public ITextComponent getDisplayName() {
					return new StringTextComponent("${data.name}");
				}

				@Override public Container createMenu(int id, PlayerInventory inventory, EntityPlayer player) {
					PacketBuffer packetBuffer = new PacketBuffer(Unpooled.buffer());
					packetBuffer.writeBlockPos(entity.getPosition());
					packetBuffer.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
					return new ${data.guiBoundTo}Menu(id, inventory, packetBuffer);
				}
			}, buf -> {
				buf.writeBlockPos(entity.getPosition());
				buf.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
			});
		}
		</#if>

		<#if hasProcedure(data.onRightClickedInAir)>
			<@procedureCode data.onRightClickedInAir, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "world",
				"entity": "entity",
				"itemstack": "ar.getResult()"
			}/>
		</#if>
		return ar;
	}
	</#if>

	<#if hasProcedure(data.onFinishUsingItem) || data.hasEatResultItem()>
		@Override public ItemStack onItemUseFinish(ItemStack itemstack, World world, EntityLivingBase entity) {
			ItemStack retval =
				<#if data.hasEatResultItem()>
					${mappedMCItemToItemStackCode(data.eatResultItem, 1)};
				</#if>
			super.onItemUseFinish(itemstack, world, entity);

			<#if hasProcedure(data.onFinishUsingItem)>
				double x = entity.posX;
				double y = entity.posY;
				double z = entity.posZ;
				<@procedureOBJToCode data.onFinishUsingItem/>
			</#if>

			<#if data.hasEatResultItem()>
				if (itemstack.isEmpty()) {
					return retval;
				} else {
					if (entity instanceof EntityPlayer && !((EntityPlayer) entity).capabilities.isCreativeMode) {
						if (!((EntityPlayer) entity).inventory.addItemStackToInventory(retval))
							((EntityPlayer) entity).dropItem(retval, false);
					}
					return itemstack;
				}
			<#else>
				return retval;
			</#if>
		}
	</#if>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onEntityHitWith data.onEntityHitWith, (data.damageCount != 0 && data.enableMeleeDamage), 1/>

	<@onEntitySwing data.onEntitySwing/>

	<@onCrafted data.onCrafted/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<@onDroppedByPlayer data.onDroppedByPlayer/>

	<@onItemEntityDestroyed data.onItemEntityDestroyed/>

	<#if data.hasInventory()>
	@Override public ICapabilityProvider initCapabilities(ItemStack stack, @Nullable NBTTagCompound compound) {
		return new ${name}InventoryCapability();
	}

	@Override public NBTTagCompound getShareTag(ItemStack stack) {
		if(!stack.hasTagCompound())
		    stack.setTagCompound(new NBTTagCompound());

		NBTTagCompound nbt = stack.getTagCompound();
		if(stack.hasCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)) {
		    ItemStackHandler capability = stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		    nbt.setTag("Inventory", capability.serializeNBT());
		}
		return nbt;
	}

	@Override public void readShareTag(ItemStack stack, @Nullable NBTTagCompound nbt) {
		super.readShareTag(stack, nbt);
		if(nbt != null && stack.hasCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)) {
		    ItemStackHandler capability = stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
			capability.deserializeNBT((NBTTagCompound) nbt.getTag("Inventory"));
        }
	}
	</#if>

	<#if hasProcedure(data.onStoppedUsing) || (data.enableRanged && !data.shootConstantly)>
		@Override public void onPlayerStoppedUsing(ItemStack itemstack, World world, EntityLivingBase entity, int time) {
			<#if hasProcedure(data.onStoppedUsing)>
				<@procedureCode data.onStoppedUsing, {
					"x": "entity.posX",
					"y": "entity.posY",
					"z": "entity.posZ",
					"world": "world",
					"entity": "entity",
					"itemstack": "itemstack",
					"time": "time"
				}/>
			</#if>
			<#if data.enableRanged && !data.shootConstantly>
				if (!world.isRemote && entity instanceof EntityPlayerMP) {
					<#if data.rangedItemChargesPower>
						float pullingPower = ItemBow.getArrowVelocity(this.getMaxItemUseDuration(itemstack) - time);
						if (pullingPower < 0.1)
							return;
					</#if>
					<@arrowShootCode/>
				}
			</#if>
		}
	</#if>

	<#if hasProcedure(data.everyTickWhileUsing) || (data.enableRanged && data.shootConstantly)>
		@Override public void onUsingTick(ItemStack itemstack, EntityLivingBase entity, int time) {
			<#if hasProcedure(data.everyTickWhileUsing)>
				<@procedureCode data.everyTickWhileUsing, {
            		"x": "entity.posX",
            		"y": "entity.posY",
            		"z": "entity.posZ",
            		"world": "entity.world",
            		"entity": "entity",
            		"itemstack": "itemstack",
            		"time": "time"
            	}/>
            </#if>
			<#if data.enableRanged && data.shootConstantly>
			    World world = entity.world;
				if (!world.isRemote && entity instanceof EntityPlayerMP) {
					<@arrowShootCode/>
					entity.stopActiveHand();
				}
			</#if>
		}
	</#if>

	<#if data.enableRanged>
	private static ItemStack getHeldAmmo(EntityLivingBase living, Predicate<ItemStack> isAmmo) {
	    if (isAmmo.test(living.getHeldItem(EnumHand.OFF_HAND))) {
	        return living.getHeldItem(EnumHand.OFF_HAND);
	    } else {
	        return isAmmo.test(living.getHeldItem(EnumHand.MAIN_HAND)) ? living.getHeldItem(EnumHand.MAIN_HAND) : ItemStack.EMPTY;
	    }
	}

	private ItemStack findAmmo(EntityPlayer player) {
		<#if data.projectileDisableAmmoCheck>
		return new ItemStack(${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)});
		<#else>
		ItemStack stack = getHeldAmmo(player, e -> e.getItem() == ${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)});
		if(stack == ItemStack.EMPTY) {
			for (int i = 0; i < player.inventory.mainInventory.size(); i++) {
				ItemStack teststack = player.inventory.mainInventory.get(i);
				if(teststack != null && teststack.getItem() == ${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)}) {
					stack = teststack;
					break;
				}
			}
		}
		return stack;
		</#if>
	}
	</#if>
}

<#macro arrowShootCode>
	<#assign projectile = data.projectile.getUnmappedValue()>
	ItemStack stack = findAmmo((EntityPlayerMP) entity);
	if (((EntityPlayerMP) entity).capabilities.isCreativeMode || stack != ItemStack.EMPTY) {
		<#assign projectileClass = generator.map(projectile, "projectiles", 0)>
		<#if projectile.startsWith("CUSTOM:")>
			${projectileClass} projectile = ${projectileClass}.shoot(world, entity, itemRand<#if data.rangedItemChargesPower>, pullingPower</#if>);
		<#else>
			${projectileClass} projectile = new ${projectileClass}(world, entity);
			projectile.shoot(entity, entity.rotationPitch, entity.rotationYaw, 0, <#if data.rangedItemChargesPower>pullingPower * </#if>3.15f, 1.0F);
			world.spawnEntity(projectile);
			world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
				.getValue(new ResourceLocation("entity.arrow.shoot")), SoundCategory.PLAYERS, 1, 1f / (itemRand.nextFloat() * 0.5f + 1));
		</#if>

		<#if data.damageCount != 0>
		itemstack.damageItem(1, entity);
		</#if>

		if (((EntityPlayerMP) entity).capabilities.isCreativeMode) {
			projectile.pickupStatus = EntityArrow.PickupStatus.CREATIVE_ONLY;
		} else {
			if (stack.isItemStackDamageable()) {
				if (stack.attemptDamageItem(1, itemRand, ((EntityPlayerMP) entity))) {
					stack.shrink(1);
					stack.setItemDamage(0);
					if (stack.isEmpty())
						((EntityPlayerMP) entity).inventory.deleteStack(stack);
				}
			} else {
				stack.shrink(1);
				if (stack.isEmpty())
				   ((EntityPlayerMP) entity).inventory.deleteStack(stack);
			}
		}

		<#if hasProcedure(data.onRangedItemUsed)>
			<@procedureCode data.onRangedItemUsed, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "world",
				"entity": "entity",
				"itemstack": "itemstack"
			}/>
		</#if>
	}
</#macro>
</@javacompress>
<#-- @formatter:on -->
