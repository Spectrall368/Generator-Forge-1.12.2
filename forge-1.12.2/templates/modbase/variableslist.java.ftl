<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.class, SavedDataSyncMessage::buffer, SavedDataSyncMessage::new, SavedDataSyncMessage::handler);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			CapabilityManager.INSTANCE.register(PlayerVariables.class, new PlayerVariablesStorage(), PlayerVariables::new);
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.class, PlayerVariablesSyncMessage::buffer, PlayerVariablesSyncMessage::new, PlayerVariablesSyncMessage::handler);
		</#if>
	}

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT") || w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	@Mod.EventBusSubscriber public static class EventBusVariableHandlers {

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		@SubscribeEvent public static void onPlayerLoggedInSyncPlayerVariables(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerLoggedInEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void onPlayerRespawnedSyncPlayerVariables(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerRespawnEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void onPlayerChangedDimensionSyncPlayerVariables(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerChangedDimensionEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void clonePlayer(PlayerEvent.Clone event) {
			//event.getOriginal().revive();

			PlayerVariables original = ((PlayerVariables) event.getOriginal().getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables()));
			PlayerVariables clone = ((PlayerVariables) event.getEntity().getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables()));
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
		</#if>

		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
		@SubscribeEvent public static void onPlayerLoggedIn(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerLoggedInEvent event) {
			if (!event.player.world.isRemote) {
				WorldSavedData mapdata = MapVariables.get(event.player.world);
				WorldSavedData worlddata = WorldVariables.get(event.player.world);
				if(mapdata != null)
					${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(0, mapdata), event.player);
				if(worlddata != null)
					${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(1, worlddata), event.player);
			}
		}

		@SubscribeEvent public static void onPlayerChangedDimension(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerChangedDimensionEvent event) {
			if (!event.player.world.isRemote) {
				WorldSavedData worlddata = WorldVariables.get(event.player.world);
				if(worlddata != null)
					${JavaModName}.PACKET_HANDLER.sendTo(new SavedDataSyncMessage(1, worlddata), event.player);
			}
		}
		</#if>
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

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

		public void syncData(World world) {
			this.markDirty();

			if (!world.isRemote)
				${JavaModName}.PACKET_HANDLER.sendToAll(new SavedDataSyncMessage(1, this));
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(World world) {
			if (world instanceof WorldServer) {
				return ((WorldServer) world).getMapStorage().getOrLoadData(WorldVariables.class, DATA_NAME);
			} else {
				return clientSide;
			}
		}

	}

	public static class MapVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

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

		public void syncData(World world) {
			this.markDirty();

			if (!world.isRemote)
				${JavaModName}.PACKET_HANDLER.sendToDimension(new SavedDataSyncMessage(0, this), world.provider.getDimension());
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(World world) {
			if (world instanceof WorldServer) {
				return ((WorldServer) world).getPerWorldStorage().getOrLoadData(MapVariables.class, DATA_NAME);
			} else {
				return clientSide;
			}
		}

	}

	public static class SavedDataSyncMessage {

		private final int type;
		private WorldSavedData data;

		public SavedDataSyncMessage(io.netty.buffer.ByteBuf buffer) {
			this.type = buffer.readInt();

			NBTTagCompound nbt = buffer.readCompoundTag();
			if (nbt != null) {
				this.data = this.type == 0 ? new MapVariables() : new WorldVariables();
				if(this.data instanceof MapVariables)
					((MapVariables) this.data).readFromNBT(nbt);
				else if(this.data instanceof WorldVariables)
					((WorldVariables) this.data).readFromNBT(nbt);
			}
		}

		public SavedDataSyncMessage(int type, WorldSavedData data) {
			this.type = type;
			this.data = data;
		}

		public static void buffer(SavedDataSyncMessage message, io.netty.buffer.ByteBuf buffer) {
			buffer.writeInt(message.type);
			if (message.data != null)
				buffer.writeCompoundTag(message.data.write(new CompoundNBT()));
		}

		public static void handler(SavedDataSyncMessage message, Supplier<NetworkEvent.Context> contextSupplier) {
			NetworkEvent.Context context = contextSupplier.get();
			context.enqueueWork(() -> {
				if (!context.getDirection().getReceptionSide().isServer() && message.data != null) {
					if (message.type == 0)
						MapVariables.clientSide = (MapVariables) message.data;
					else
						WorldVariables.clientSide = (WorldVariables) message.data;
				}
			});
			context.setPacketHandled(true);
		}

	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	@CapabilityInject(PlayerVariables.class) public static Capability<PlayerVariables> PLAYER_VARIABLES_CAPABILITY = null;

	@Mod.EventBusSubscriber private static class PlayerVariablesProvider implements ICapabilitySerializable<INBT> {

		@SubscribeEvent public static void onAttachCapabilities(AttachCapabilitiesEvent<Entity> event) {
			if (event.getObject() instanceof EntityPlayer && !(event.getObject() instanceof FakePlayer))
				event.addCapability(new ResourceLocation("${modid}", "player_variables"), new PlayerVariablesProvider());
		}

		private final PlayerVariables playerVariables = new PlayerVariables();

		private final LazyOptional<PlayerVariables> instance = LazyOptional.of(PLAYER_VARIABLES_CAPABILITY::getDefaultInstance);

		@Override public <T> LazyOptional<T> getCapability(Capability<T> cap, Direction side) {
			return cap == PLAYER_VARIABLES_CAPABILITY ? instance.cast() : LazyOptional.empty();
		}

		@Override public INBT serializeNBT() {
			return PLAYER_VARIABLES_CAPABILITY.getStorage().writeNBT(PLAYER_VARIABLES_CAPABILITY, this.instance.orElseThrow(RuntimeException::new), null);
		}

		@Override public void deserializeNBT(INBT nbt) {
			PLAYER_VARIABLES_CAPABILITY.getStorage().readNBT(PLAYER_VARIABLES_CAPABILITY, this.instance.orElseThrow(RuntimeException::new), null, nbt);
		}

	}

	private static class PlayerVariablesStorage implements Capability.IStorage<PlayerVariables> {

		@Override public INBT writeNBT(Capability<PlayerVariables> capability, PlayerVariables instance, Direction side) {
			CompoundNBT nbt = new CompoundNBT();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		@Override public void readNBT(Capability<PlayerVariables> capability, PlayerVariables instance, Direction side, INBT inbt) {
			CompoundNBT nbt = (CompoundNBT) inbt;
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

	}

	public static class PlayerVariables {

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		public void syncPlayerVariables(Entity entity) {
			if (entity instanceof ServerPlayerEntity)
				${JavaModName}.PACKET_HANDLER.send(new PlayerVariablesSyncMessage(this), (ServerPlayerEntity) entity);
		}

	}

	public static class PlayerVariablesSyncMessage {

		private final PlayerVariables data;

		public PlayerVariablesSyncMessage(io.netty.buffer.ByteBuf buffer) {
			this.data = new PlayerVariables();
			new PlayerVariablesStorage().readFromNBT(null, this.data, null, buffer.readCompoundTag());
		}

		public PlayerVariablesSyncMessage(PlayerVariables data) {
			this.data = data;
		}

		public static void buffer(PlayerVariablesSyncMessage message, io.netty.buffer.ByteBuf buffer) {
			buffer.writeCompoundTag((NBTTagCompound) new PlayerVariablesStorage().writeToNBT(null, message.data, null));
		}

		public static void handler(PlayerVariablesSyncMessage message, Supplier<NetworkEvent.Context> contextSupplier) {
			NetworkEvent.Context context = contextSupplier.get();
			context.enqueueWork(() -> {
				if (!context.getDirection().getReceptionSide().isServer()) {
					PlayerVariables variables = ((PlayerVariables) Minecraft.getInstance().player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables()));
					<#list variables as var>
						<#if var.getScope().name() == "PLAYER_LIFETIME" || var.getScope().name() == "PLAYER_PERSISTENT">
						variables.${var.getName()} = message.data.${var.getName()};
						</#if>
					</#list>
				}
			});
			context.setPacketHandled(true);
		}
	}
	</#if>
}
<#-- @formatter:on -->
