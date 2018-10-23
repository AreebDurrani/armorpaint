import bpy
import arm.material.mat_utils
import arm.write_data
import arm.assets
import arm.make_renderpath
import arm.make_state

def on_make_renderpath():
	arm.assets.add_shader_pass('max_luminance_pass')
	arm.assets.add_shader_pass('copy_mrt3_pass')
	arm.assets.add_shader_pass('copy_mrt4_pass')

	if bpy.data.worlds['Arm'].arm_project_name == 'ArmorPaint':
		if arm.make_state.target == 'krom':
			arm.material.mat_utils.add_mesh_contexts = ['voxel'] # Defaults to make_ao
			arm.write_data.add_compiledglsl = """
				const ivec3 voxelgiResolution = ivec3(256, 256, 256);
				const vec3 voxelgiHalfExtents = vec3(2.0, 2.0, 2.0);
			"""
		else:
			arm.material.mat_utils.add_mesh_contexts = []

def register():
	arm.make_renderpath.callback = on_make_renderpath
