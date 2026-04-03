package net.mcreator.packloader;

import net.minecraftforge.fml.relauncher.SideOnly;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.common.event.FMLPreInitializationEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.client.FMLClientHandler;

import net.minecraft.client.resources.ResourcePackRepository;
import net.minecraft.client.Minecraft;

import java.util.List;
import java.util.ArrayList;

import java.io.File;

@Mod(modid = PackLoaderMod.MODID, name = PackLoaderMod.MODID, version = "1.0.0", clientSideOnly = true)
public class PackLoaderMod {

    public static final String MODID = "packloader";

    @Mod.EventHandler @SideOnly(Side.CLIENT)
    public void preInit(FMLPreInitializationEvent event) {
        List<String> resourcePacks = new ArrayList<>();
        Minecraft mc = Minecraft.getMinecraft();
        File resourcePacksDir = new File(mc.mcDataDir, "resourcepacks");

        if (resourcePacksDir.exists() && resourcePacksDir.isDirectory()) {
            File[] files = resourcePacksDir.listFiles();
            if (files != null) {
                for (File file : files) {
                    resourcePacks.add(file.getName());
                }
            }
        }

        boolean anyChanged = false;
        ResourcePackRepository repo = mc.getResourcePackRepository();
        List<ResourcePackRepository.Entry> selectedPacks = new ArrayList<>(repo.getRepositoryEntries());

        for (ResourcePackRepository.Entry entry : repo.getRepositoryEntriesAll()) {
            for (String resourcePack : resourcePacks) {
                if (entry.getResourcePackName().contains(resourcePack)) {
                    if (!selectedPacks.contains(entry)) {
                        anyChanged = true;
                        selectedPacks.add(entry);
                    }
                }
            }
        }

        if (anyChanged) {
            repo.setRepositories(selectedPacks);
            repo.updateRepositoryEntriesAll();
            FMLClientHandler.instance().refreshResources();
        }
    }
}