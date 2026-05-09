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
<#include "../procedures.java.ftl">

package ${package}.network;

public class ${name}SliderMessage implements IMessage {
	private final int sliderID, x, y, z;
	private final double value;

	public ${name}SliderMessage(int sliderID, int x, int y, int z, double value) {
		this.sliderID = sliderID;
		this.x = x;
		this.y = y;
		this.z = z;
		this.value = value;
	}

	@Override public void fromBytes(ByteBuf buffer) {
		this.sliderID = buffer.readInt();
		this.x = buffer.readInt();
		this.y = buffer.readInt();
		this.z = buffer.readInt();
		this.value = buffer.readDouble();
	}

	@Override public void toBytes(ByteBuf buffer) {
	    buffer.writeInt(sliderID);
	    buffer.writeInt(x);
	    buffer.writeInt(y);
	    buffer.writeInt(z);
	    buffer.writeDouble(value);
	}

    public static class ${name}SliderMessageHandler implements IMessageHandler<${name}SliderMessage, IMessage> {
        @Override public IMessage onMessage(${name}SliderMessage message, MessageContext context) {
            context.getServerHandler().player.getServerWorld().addScheduledTask(() -> handleSliderAction(context.getServerHandler().player, message.sliderID, message.x, message.y, message.z, message.value));

            return null;
        }
    }

	public static void handleSliderAction(EntityPlayer entity, int sliderID, int x, int y, int z, double value) {
		World world = entity.world;

		// security measure to prevent arbitrary chunk generation
		if (!world.isBlockLoaded(new BlockPos(x, y, z)))
			return;

		<#assign slid = 0>
		<#list data.getComponentsOfType("Slider") as component>
			<#if hasProcedure(component.whenSliderMoves)>
				if (sliderID == ${slid}) {
					<@procedureOBJToCode component.whenSliderMoves/>
				}
			</#if>
			<#assign slid +=1>
		</#list>
	}

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(${name}SliderMessageHandler.class, ${name}SliderMessage.class, Side.SERVER);
	}
}
<#-- @formatter:on -->