<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

import net.minecraft.nbt.NBTBase;
import net.minecraftforge.fml.common.gameevent.PlayerEvent;

public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	public static void init() {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.SavedDataSyncMessageHandler.class, SavedDataSyncMessage.class, Side.SERVER, Side.CLIENT);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			CapabilityManager.INSTANCE.register(PlayerVariables.class, new PlayerVariablesStorage(), PlayerVariables::new);
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.PlayerVariablesSyncMessageHandler.class, PlayerVariablesSyncMessage.class, Side.SERVER, Side.CLIENT);
		</#if>
	}

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
    @Mod.EventBusSubscriber public static class EventBusVariableHandlers {
		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
        @SubscribeEvent public static void onPlayerLoggedInSyncPlayerVariables(PlayerEvent.PlayerLoggedInEvent event) {
            if (event.player instanceof EntityPlayerMP && event.player.hasCapability(PLAYER_VARIABLES, null)) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                ${JavaModName}.PACKET_HANDLER.sendTo(new PlayerVariablesSyncMessage(player.getCapability(PLAYER_VARIABLES, null)), player);
            }
        }

        @SubscribeEvent public static void onPlayerRespawnedSyncPlayerVariables(PlayerEvent.PlayerRespawnEvent event) {
            if (event.player instanceof EntityPlayerMP && event.player.hasCapability(PLAYER_VARIABLES, null)) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                ${JavaModName}.PACKET_HANDLER.sendTo(new PlayerVariablesSyncMessage(player.getCapability(PLAYER_VARIABLES, null)), player);
            }
        }

        @SubscribeEvent public static void onPlayerChangedDimensionSyncPlayerVariables(PlayerEvent.PlayerChangedDimensionEvent event) {
            if (event.player instanceof EntityPlayerMP && event.player.hasCapability(PLAYER_VARIABLES, null)) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                ${JavaModName}.PACKET_HANDLER.sendTo(new PlayerVariablesSyncMessage(player.getCapability(PLAYER_VARIABLES, null)), player);
            }
        }

        @SubscribeEvent public static void onPlayerTickUpdateSyncPlayerVariables(TickEvent.PlayerTickEvent event) {
            if (event.phase == TickEvent.Phase.END && event.player instanceof EntityPlayerMP && event.player.hasCapability(PLAYER_VARIABLES, null)) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                PlayerVariables capability = player.getCapability(PLAYER_VARIABLES, null);
                    if (capability._syncDirty) {
                        ${JavaModName}.PACKET_HANDLER.sendTo(new PlayerVariablesSyncMessage(capability), player);
                        capability._syncDirty = false;
                    }
            }
        }

        @SubscribeEvent public static void clonePlayer(net.minecraftforge.event.entity.player.PlayerEvent.Clone event) {
            if (event.getOriginal().hasCapability(PLAYER_VARIABLES, null) && event.getEntityPlayer().hasCapability(PLAYER_VARIABLES, null)) {
                PlayerVariables original = event.getOriginal().getCapability(PLAYER_VARIABLES, null);
                PlayerVariables clone = event.getEntityPlayer().getCapability(PLAYER_VARIABLES, null);

                    <#list variables as var>
                        <#if var.getScope().name() == "PLAYER_PERSISTENT">
                        clone.${var.getName()} = original.${var.getName()};
                        </#if>
                    </#list>
                    if(!event.isWasDeath()) {
                        <#list variables as var>
                            <#if var.getScope().name() == "PLAYER_LIFETIME">
                            clone.${var.getName()} = original.${var.getName()};
                            </#if>
                        </#list>
                    }
            }
        }
        </#if>

        <#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
        @SubscribeEvent public static void onPlayerLoggedIn(PlayerEvent.PlayerLoggedInEvent event) {
            if (event.player instanceof EntityPlayerMP) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                WorldSavedData mapdata = MapVariables.get(player.world);
                WorldSavedData worlddata = WorldVariables.get(player.world);
                if(mapdata != null)
                    ${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(0, mapdata), player);
                if(worlddata != null)
                    ${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(1, worlddata), player);
            }
        }

        @SubscribeEvent public static void onPlayerChangedDimension(PlayerEvent.PlayerChangedDimensionEvent event) {
            if (event.player instanceof EntityPlayerMP) {
                EntityPlayerMP player = (EntityPlayerMP) event.player;
                WorldSavedData worlddata = WorldVariables.get(player.world);
                if(worlddata != null)
                    ${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(1, worlddata), player);
            }
        }

        @SubscribeEvent public static void onWorldTick(TickEvent.WorldTickEvent event) {
            if (event.phase == TickEvent.Phase.END && event.world instanceof WorldServer) {
                WorldVariables worldVariables = WorldVariables.get(event.world);
                if (worldVariables._syncDirty) {
                    ${JavaModName}.PACKET_HANDLER.sendToDimension(new SavedDataSyncMessage(1, worldVariables), event.world.provider.getDimension());
                    worldVariables._syncDirty = false;
                }

                MapVariables mapVariables = MapVariables.get(event.world);
                if (mapVariables._syncDirty) {
                    ${JavaModName}.PACKET_HANDLER.sendToAll(new SavedDataSyncMessage(0, mapVariables));
                    mapVariables._syncDirty = false;
                }
            }
        }
		</#if>
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public WorldVariables() {
			super(DATA_NAME);
		}

		public WorldVariables(String s) {
			super(s);
		}

		@Override public void readFromNBT(NBTTagCompound nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public NBTTagCompound writeToNBT(NBTTagCompound nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.markDirty();
			this._syncDirty = true;
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(World world) {
			if (world instanceof WorldServer) {
                WorldVariables instance = (WorldVariables) world.getPerWorldStorage().getOrLoadData(WorldVariables.class, DATA_NAME);
                if (instance == null) {
                    instance = new WorldVariables();
                    world.getPerWorldStorage().setData(DATA_NAME, instance);
                }
                return instance;
			} else {
				return clientSide;
			}
		}
	}

	public static class MapVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public MapVariables() {
			super(DATA_NAME);
		}

		public MapVariables(String s) {
			super(s);
		}

		@Override public void readFromNBT(NBTTagCompound nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public NBTTagCompound writeToNBT(NBTTagCompound nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.markDirty();
			_syncDirty = true;
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(World world) {
			if (world instanceof WorldServer) {
                MapVariables instance = (MapVariables) world.loadData(MapVariables.class, DATA_NAME);
                if (instance == null) {
                    instance = new MapVariables();
                    world.setData(DATA_NAME, instance);
                }
                return instance;
			} else {
				return clientSide;
			}
		}
	}

	public static class SavedDataSyncMessage implements IMessage {
		private int dataType;
		private WorldSavedData data;

		public SavedDataSyncMessage() {}

		public SavedDataSyncMessage(int dataType, WorldSavedData data) {
			this.dataType = dataType;
			this.data = data;
		}

		@Override public void fromBytes(ByteBuf buffer) {
		    int dataType = buffer.readInt();
		    NBTTagCompound nbt = ByteBufUtils.readTag(buffer);
		    WorldSavedData data = null;
		    if (nbt != null) {
		        data = dataType == 0 ? new MapVariables() : new WorldVariables();
		        data.readFromNBT(nbt);
		    }

		    this.dataType = dataType;
		    this.data = data;
		}

		@Override public void toBytes(ByteBuf buffer) {
		    buffer.writeInt(dataType);
		    if (data != null)
		        ByteBufUtils.writeTag(buffer, data.writeToNBT(new NBTTagCompound()));
		}

		public static class SavedDataSyncMessageHandler implements IMessageHandler<SavedDataSyncMessage, IMessage> {
            @Override public IMessage onMessage(SavedDataSyncMessage message, MessageContext context) {
                Minecraft.getMinecraft().addScheduledTask(() -> {
                    if (message.data != null) {
                        if (message.dataType == 0)
                            MapVariables.clientSide.readFromNBT(message.data.writeToNBT(new NBTTagCompound()));
                        else
                            WorldVariables.clientSide.readFromNBT(message.data.writeToNBT(new NBTTagCompound()));
                    }
                });

                return null;
            }
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	@CapabilityInject(PlayerVariables.class) public static Capability<PlayerVariables> PLAYER_VARIABLES = null;

	@Mod.EventBusSubscriber private static class PlayerVariablesProvider implements ICapabilitySerializable<NBTBase> {
		@SubscribeEvent public static void onAttachCapabilities(AttachCapabilitiesEvent<Entity> event) {
			if (event.getObject() instanceof EntityPlayer && !(event.getObject() instanceof FakePlayer))
				event.addCapability(new ResourceLocation("${modid}", "player_variables"), new PlayerVariablesProvider());
		}

		private final PlayerVariables instance = PLAYER_VARIABLES.getDefaultInstance();

		@Override public boolean hasCapability(Capability<?> cap, @Nullable EnumFacing side) {
			return cap == PLAYER_VARIABLES;
		}

		@Override @Nullable public <T> T getCapability(Capability<T> capability, @Nullable EnumFacing facing) {
			return hasCapability(capability, facing) ? PLAYER_VARIABLES.cast(instance) : null;
		}

		@Override public NBTBase serializeNBT() {
			return PLAYER_VARIABLES.writeNBT(instance, null);
		}

		@Override public void deserializeNBT(NBTBase nbt) {
			PLAYER_VARIABLES.readNBT(instance, null, nbt);
		}
	}

	public static class PlayerVariables implements INBTSerializable<NBTTagCompound> {

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		@Override public NBTTagCompound serializeNBT() {
			NBTTagCompound nbt = new NBTTagCompound();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		@Override public void deserializeNBT(NBTTagCompound nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public void markSyncDirty() {
			_syncDirty = true;
		}
	}

	private static class PlayerVariablesStorage implements Capability.IStorage<PlayerVariables> {
		@Override public NBTBase writeNBT(Capability<PlayerVariables> capability, PlayerVariables instance, EnumFacing side) {
			return instance.serializeNBT();
		}

		@Override public void readNBT(Capability<PlayerVariables> capability, PlayerVariables instance, EnumFacing side, NBTBase inbt) {
			instance.deserializeNBT((NBTTagCompound) inbt);
		}
	}

	public static class PlayerVariablesSyncMessage implements IMessage {
	    private static final PlayerVariablesStorage playerStorage = new PlayerVariablesStorage();
	    private PlayerVariables data;

	    public PlayerVariablesSyncMessage() {}

	    public PlayerVariablesSyncMessage(PlayerVariables data) {
	        this.data = data;
	    }

		@Override public void fromBytes(ByteBuf buffer) {
			this.data = new PlayerVariables();
			playerStorage.readNBT(null, this.data, null, ByteBufUtils.readTag(buffer));
		}

		@Override public void toBytes(ByteBuf buffer) {
			ByteBufUtils.writeTag(buffer, (NBTTagCompound) playerStorage.writeNBT(null, data, null));
		}

		public static class PlayerVariablesSyncMessageHandler implements IMessageHandler<PlayerVariablesSyncMessage, IMessage> {
            @Override public IMessage onMessage(PlayerVariablesSyncMessage message, MessageContext context) {
                Minecraft.getMinecraft().addScheduledTask(() -> {
                    EntityPlayer player = Minecraft.getMinecraft().player;
                    if (message.data != null && player.hasCapability(PLAYER_VARIABLES, null)) {
                        PlayerVariables cap = player.getCapability(PLAYER_VARIABLES, null);
                        <#list variables as var>
                            <#if var.getScope().name() == "PLAYER_LIFETIME" || var.getScope().name() == "PLAYER_PERSISTENT">
                            cap.${var.getName()} = message.data.${var.getName()};
                            </#if>
                        </#list>
                    }
                });

                return null;
            }
		}
	}
	</#if>
}
<#-- @formatter:on -->