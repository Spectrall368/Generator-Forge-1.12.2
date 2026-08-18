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
public net.minecraft.entity.projectile.EntityArrow field_184552_b # ARROW_TARGETS
</#if>

<#if w.hasElementsOfType('tool')>
protected-f net.minecraft.item.ItemHoe field_185072_b # speed
protected net.minecraft.item.ItemSword field_150934_a # attackDamage
</#if>

<#if w.hasElementsOfType('particle')>
public net.minecraft.util.EnumParticleTypes field_186837_Z # BY_NAME
public net.minecraft.util.EnumParticleTypes field_179365_U # PARTICLES
</#if>

<#if w.hasElementsOfType('biome')>
public-f net.minecraft.world.gen.structure.MapGenScatteredFeature field_75061_e # BIOMELIST
public-f net.minecraft.world.gen.structure.WoodlandMansion field_191072_a # ALLOWED_BIOMES
</#if>

public net.minecraft.block.Block field_176227_L # blockState

# Start of user code block custom ATs
# End of user code block custom ATs