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
<#include "procedures.java.ftl">
package ${package}.network;

import ${package}.${JavaModName};

public class ${name}Message implements IMessage {
	int type, pressedms;

	public ${name}Message() {}

	public ${name}Message(int type, int pressedms) {
		this.type = type;
		this.pressedms = pressedms;
	}

	@Override public void fromBytes(ByteBuf buffer) {
		type = buffer.readInt();
		pressedms = buffer.readInt();
	}

	@Override public void toBytes(ByteBuf buffer) {
		buffer.writeInt(type);
		buffer.writeInt(pressedms);
	}

	<#if hasProcedure(data.onKeyPressed) || hasProcedure(data.onKeyReleased)>
	public static void pressAction(EntityPlayer entity, int type, int pressedms) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;

		// security measure to prevent arbitrary chunk generation
		if (!world.isBlockLoaded(entity.getPosition()))
			return;

		<#if hasProcedure(data.onKeyPressed)>
		if(type == 0) {
			<@procedureOBJToCode data.onKeyPressed/>
		}
		</#if>

		<#if hasProcedure(data.onKeyReleased)>
		if(type == 1) {
			<@procedureOBJToCode data.onKeyReleased/>
		}
		</#if>
	}
	</#if>

    public static class ${name}MessageHandler implements IMessageHandler<${name}Message, IMessage> {
        @Override public IMessage onMessage(${name}Message message, MessageContext context) {
	    	EntityPlayerMP entity = context.getServerHandler().player;
	    	entity.getServerWorld().addScheduledTask(() -> {
				<#if hasProcedure(data.onKeyPressed) || hasProcedure(data.onKeyReleased)>
				pressAction(entity, message.type, message.pressedms);
				</#if>
	    	});

            return null;
        }
    }

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(${name}MessageHandler.class, ${name}Message.class, Side.SERVER);
	}
}
<#-- @formatter:on -->