<#if w.hasElementsOfType('gui')>
public net.minecraft.client.gui.GuiTextField field_146226_p # isEnabled
public net.minecraft.client.gui.GuiTextField field_146222_t # enabledColor
public net.minecraft.client.gui.GuiTextField field_146221_u # disabledColor
public net.minecraft.client.gui.GuiTextField field_146224_r # cursorPosition
public net.minecraft.client.gui.GuiTextField field_146225_q # lineScrollOffset
public net.minecraft.client.gui.GuiTextField field_146223_s # selectionEnd
public net.minecraft.client.gui.GuiTextField field_146216_j # text
public net.minecraft.client.gui.GuiTextField field_146211_a # fontRenderer
public net.minecraft.client.gui.GuiTextField field_146213_o # isFocused
public net.minecraft.client.gui.GuiTextField field_146214_l # cursorCounter
public net.minecraft.client.gui.GuiTextField field_146215_m # enableBackgroundDrawing

public net.minecraft.client.gui.GuiTextField func_146188_c(IIII)V # drawSelectionBox

public net.minecraft.client.gui.GuiButtonImage field_191750_o # resourceLocation
public net.minecraft.client.gui.GuiButtonImage field_191747_p # xTexStart
public net.minecraft.client.gui.GuiButtonImage field_191748_q # yTexStart
public net.minecraft.client.gui.GuiButtonImage field_191749_r # yDiffText
</#if>

<#if w.hasElementsOfType('livingentity')>
public-f net.minecraft.entity.Entity func_70045_F()Z # isImmuneToFire
</#if>

<#if w.hasElementsOfType('projectile')>
public net.minecraft.entity.projectile.EntityArrow ARROW_TARGETS # ARROW_TARGETS
</#if>

<#if w.hasElementsOfType('tool')>
protected-f net.minecraft.item.ItemHoe speed # speed
protected net.minecraft.item.ItemSword attackDamage # attackDamage
</#if>

<#if w.hasElementsOfType('particle')>
public net.minecraft.util.EnumParticleTypes BY_NAME # BY_NAME
public net.minecraft.util.EnumParticleTypes PARTICLES # PARTICLES
</#if>

<#if w.hasElementsOfType('biome')>
public-f net.minecraft.world.gen.structure.MapGenScatteredFeature BIOMELIST # BIOMELIST
public-f net.minecraft.world.gen.structure.WoodlandMansion ALLOWED_BIOMES # ALLOWED_BIOMES
</#if>

public net.minecraft.block.Block blockState # blockState
public net.minecraft.item.ItemBucket containedBlock # containedBlock

# Start of user code block custom ATs
# End of user code block custom ATs