private static Item getRandomItem(String name) {
		NonNullList<ItemStack> tag = OreDictionary.getOres(name);
		return tag.isEmpty() ? Items.AIR : tag.get(new Random().nextInt(tag.size())).getItem();
}