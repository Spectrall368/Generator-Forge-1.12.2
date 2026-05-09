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

public class MenuStateUpdateMessage implements IMessage {
    private final int elementType;
    private final String name;
    private final Object elementState;

    public MenuStateUpdateMessage(int elementType, String name, Object elementState) {
        this.elementType = elementType;
        this.name = name;
        this.elementState = elementState;
    }

	@Override public void fromBytes(ByteBuf buffer) {
		this.elementType = buffer.readInt();
		this.name = ByteBufUtils.readUTF8String(buffer);
		Object elementState = null;
		if (elementType == 0) {
			elementState = ByteBufUtils.readUTF8String(buffer);
		} else if (elementType == 1) {
			elementState = buffer.readBoolean();
		} else if (elementType == 2) {
			elementState = buffer.readDouble();
		}
        this.elementState = elementState;
	}

	@Override public void toBytes(ByteBuf buffer) {
		buffer.writeInt(elementType);
		buffer.writeString(name);
		if (elementType == 0) {
			buffer.writeString((String) elementState);
		} else if (elementType == 1) {
			buffer.writeBoolean((boolean) elementState);
		} else if (elementType == 2 && elementState instanceof Number) {
			buffer.writeDouble(((Number) elementState).doubleValue());
		}
	}

    public static class MenuStateUpdateMessageHandler implements IMessageHandler<MenuStateUpdateMessage, IMessage> {
        @Override public IMessage onMessage(MenuStateUpdateMessage message, MessageContext context) {
            <#-- Security measure to prevent accepting too big strings -->
            if (message.name.length() > 256 || message.elementState instanceof String && ((String) message.elementState).length() > 8192)
                return null;

            context.getServerHandler().player.getServerWorld().addScheduledTask(() -> {
                if (context.getServerHandler().player.openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
                    ((${JavaModName}Menus.MenuAccessor) context.getServerHandler().player.openContainer).getMenuState().put(message.elementType + ":" + message.name, message.elementState);
                    if (!context.getDirection().getReceptionSide().isServer() && Minecraft.getInstance().currentScreen instanceof ${JavaModName}Screens.ScreenAccessor) {
                        ((${JavaModName}Screens.ScreenAccessor) Minecraft.getInstance().currentScreen).updateMenuState(message.elementType, message.name, message.elementState);
                    }
                }
            });

            return null;
        }
    }

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(MenuStateUpdateMessageHandler.class, MenuStateUpdateMessage.class, Side.SERVER);
	}
}
<#-- @formatter:on -->