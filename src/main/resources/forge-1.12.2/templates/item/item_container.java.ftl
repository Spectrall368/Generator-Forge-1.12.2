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
package ${package}.item.inventory;

<@javacompress>
@Mod.EventBusSubscriber public class ${name}InventoryCapability implements ICapabilitySerializable<NBTTagCompound> {

	@SubscribeEvent public static void onItemDropped(ItemTossEvent event) {
		if (event.getEntityItem().getItem().getItem() == ${JavaModName}Items.${REGISTRYNAME}) {
			EntityPlayer player = event.getPlayer();
			if (player.openContainer instanceof ${data.guiBoundTo}Menu)
				player.closeScreen();
		}
	}

	private final ItemStackHandler inventory = createItemHandler();

	@Override public boolean hasCapability(Capability<?> cap, @Nullable EnumFacing side) {
		return cap == CapabilityItemHandler.ITEM_HANDLER_CAPABILITY;
	}

	@Override @Nullable public <T> T getCapability(Capability<T> capability, @Nullable EnumFacing facing) {
		return hasCapability(capability, facing) ? inventory.cast(instance) : null;
	}

	@Override public NBTTagCompound serializeNBT() {
		return getItemHandler().serializeNBT();
	}

	@Override public void deserializeNBT(NBTTagCompound nbt) {
		getItemHandler().deserializeNBT(nbt);
	}

	private ItemStackHandler createItemHandler() {
		return new ItemStackHandler(${data.inventorySize}) {

			<#if data.inventoryStackSize != 99>
			@Override public int getSlotLimit(int slot) {
				return ${data.inventoryStackSize};
			}
			</#if>

			@Override public boolean isItemValid(int slot, @Nonnull ItemStack stack) {
				return stack.getItem() != ${JavaModName}Items.${REGISTRYNAME}.get();
			}

			@Override public void setSize(int size) {
			}
		};
	}

	private ItemStackHandler getItemHandler() {
		return inventory;
	}
}
</@javacompress>
<#-- @formatter:on -->