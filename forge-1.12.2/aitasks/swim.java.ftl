<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityCustom.EntityAISwimmingGoal(this, ${field$speed}, 40)<@conditionCode field$condition/>);

static class RandomSwimmingGoal extends EntityAIWander {
   public RandomSwimmingGoal(EntityCreature p_i48937_1_, double p_i48937_2_, int p_i48937_4_) {
      super(p_i48937_1_, p_i48937_2_, p_i48937_4_);
   }

   @Nullable
   protected Vec3d getPosition() {
      Vec3d vec3d = RandomPositionGenerator.findRandomTarget(this.creature, 10, 7);

      for(int i = 0; vec3d != null && !this.creature.isInWater() && i++ < 10; vec3d = RandomPositionGenerator.findRandomTarget(this.creature, 10, 7)) {
         ;
      }

      return vec3d;
   }
}
