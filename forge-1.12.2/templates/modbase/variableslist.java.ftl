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
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.class, SavedDataSyncMessage::handler, Side.SERVER, Side.CLIENT);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			CapabilityManager.INSTANCE.register(PlayerVariables.class, new PlayerVariablesStorage(), PlayerVariables::new);
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.class, PlayerVariablesSyncMessage::handler, Side.SERVER, Side.CLIENT);
		</#if>
	}

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT") || w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	@Mod.EventBusSubscriber public static class EventBusVariableHandlers {

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		@SubscribeEvent public static void onPlayerLoggedInSyncPlayerVariables(PlayerEvent.PlayerLoggedInEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void onPlayerRespawnedSyncPlayerVariables(PlayerEvent.PlayerRespawnEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.getPlayer().getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void onPlayerChangedDimensionSyncPlayerVariables(PlayerEvent.PlayerChangedDimensionEvent event) {
			if (!event.player.world.isRemote)
				((PlayerVariables) event.player.getCapability(PLAYER_VARIABLES_CAPABILITY, null).orElse(new PlayerVariables())).syncPlayerVariables(event.player);
		}

		@SubscribeEvent public static void clonePlayer(PlayerEvent.Clone event) {
			event.getOriginal().revive();

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
		@SubscribeEvent public static void onPlayerLoggedIn(PlayerEvent.PlayerLoggedInEvent event) {
			if (!event.getPlayer().world.isRemote) {
				WorldSavedData mapdata = MapVariables.get(event.player.world);
				WorldSavedData worlddata = WorldVariables.get(event.player.world);
				if(mapdata != null)
					${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (EntityPlayerMP) event.player), new SavedDataSyncMessage(0, mapdata));
				if(worlddata != null)
					${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (EntityPlayerMP) event.player), new SavedDataSyncMessage(1, worlddata));
			}
		}

		@SubscribeEvent public static void onPlayerChangedDimension(PlayerEvent.PlayerChangedDimensionEvent event) {
			if (!event.player.world.isRemote) {
				WorldSavedData worlddata = WorldVariables.get(event.player.world);
				if(worlddata != null)
					${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (EntityPlayerMP) event.player), new SavedDataSyncMessage(1, worlddata));
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
				${JavaModName}.PACKET_HANDLER.send(PacketDistributor.DIMENSION.with(world.dimension::getType), new SavedDataSyncMessage(1, this));
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(World world) {
			if (world instanceof WorldServer) {
				return ((WorldServer) world).getPerWorldStorage().getOrLoadData(WorldVariables::new, DATA_NAME);
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

		public void syncData(IWorld world) {
			this.markDirty();

			if (!world.isRemote)
				${JavaModName}.PACKET_HANDLER.send(PacketDistributor.ALL.noArg(), new SavedDataSyncMessage(0, this));
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(World world) {
			if (world instanceof WorldServer) {
				return ((WorldServer) world).getMinecraftServer().getWorld(DimensionType.OVERWORLD).getPerWorldStorage().getOrLoadData(MapVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class SavedDataSyncMessage {

		private final int type;
		private WorldSavedData data;

		public SavedDataSyncMessage(PacketBuffer buffer) {
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

		public static void buffer(SavedDataSyncMessage message, PacketBuffer buffer) {
			buffer.writeInt(message.type);
			if (message.data != null)
				buffer.writeCompoundTag(message.data.writeToNBT(new NBTTagCompound()));
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	@CapabilityInject(PlayerVariables.class) public static Capability<PlayerVariables> PLAYER_VARIABLES_CAPABILITY = null;

	@Mod.EventBusSubscriber private static class PlayerVariablesProvider implements ICapabilitySerializable<NBTBase> {

		@SubscribeEvent public static void onAttachCapabilities(AttachCapabilitiesEvent<Entity> event) {
			if (event.getObject() instanceof PlayerEntity && !(event.getObject() instanceof FakePlayer))
				event.addCapability(new ResourceLocation("${modid}", "player_variables"), new PlayerVariablesProvider());
		}

		private final PlayerVariables playerVariables = new PlayerVariables();

		private final PlayerVariables instance = PLAYER_VARIABLES_CAPABILITY.getDefaultInstance();

		@Override public boolean hasCapability(Capability<T> cap, EnumFacing side) {
			return cap == PLAYER_VARIABLES_CAPABILITY;
		}

		@Override public <T> getCapability(Capability<T> cap, EnumFacing side) {
			return cap == PLAYER_VARIABLES_CAPABILITY ? PLAYER_VARIABLES_CAPABILITY.<T> cast(this.instance.orElseThrow(RuntimeException::new)) : null;
		}

		@Override public NBTBase serializeNBT() {
			return PLAYER_VARIABLES_CAPABILITY.getStorage().writeNBT(PLAYER_VARIABLES_CAPABILITY, this.instance.orElseThrow(RuntimeException::new), null);
		}

		@Override public void deserializeNBT(NBTBase nbt) {
			PLAYER_VARIABLES_CAPABILITY.getStorage().readNBT(PLAYER_VARIABLES_CAPABILITY, this.instance.orElseThrow(RuntimeException::new), null, nbt);
		}

	}

	private static class PlayerVariablesStorage implements Capability.IStorage<PlayerVariables> {

		@Override public NBTBase writeNBT(Capability<PlayerVariables> capability, PlayerVariables instance, EnumFacing side) {
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

		@Override public void readNBT(Capability<PlayerVariables> capability, PlayerVariables instance, EnumFacing side, NBTBase inbt) {
			NBTTagCompound nbt = (NBTTagCompound) inbt;
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
				${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (EntityPlayerMP) entity), new PlayerVariablesSyncMessage(this));
		}

	}

	public static class PlayerVariablesSyncMessage {
		private final PlayerVariables data;

		public PlayerVariablesSyncMessage(PacketBuffer buffer) {
			this.data = new PlayerVariables();
			new PlayerVariablesStorage().readNBT(null, this.data, null, buffer.readCompoundTag());
		}

		public PlayerVariablesSyncMessage(PlayerVariables data) {
			this.data = data;
		}

		public static void buffer(PlayerVariablesSyncMessage message, PacketBuffer buffer) {
			buffer.writeCompoundTag((NBTTagCompound) new PlayerVariablesStorage().writeNBT(null, message.data, null));
		}
	}
	</#if>
}
<#-- @formatter:on -->
