<template>
  <el-form :model="form" label-width="100px">
    <el-form-item label="Razon social">
      <el-select v-model="form.region" placeholder="Seleccionar">
        <el-option label="Garcal" value="garcal" />
        <el-option label="LC" value="lc" />
      </el-select>
    </el-form-item>

    <el-form-item label="Nombre">
      <el-input v-model="form.name" />
    </el-form-item>
    
    <el-form-item label="Fecha">
      <el-col :span="11">
        <el-date-picker
          v-model="form.date1"
          type="date"
          placeholder="Seleccionar fecha inicio"
          style="width: 100%"
        />
      </el-col>
      <el-col :span="2" class="text-center">
        <span class="text-gray-500">-</span>
      </el-col>
      <el-col :span="11">
        <el-date-picker
          v-model="form.date1"
          type="date"
          placeholder="Seleccionar fecha fin"
          style="width: 100%"
        />
      </el-col>

    </el-form-item>
    <el-form-item label="Switch">
      <el-switch v-model="form.delivery" />
    </el-form-item>
    <el-form-item label="Check">
      <el-checkbox-group v-model="form.type">
        <el-checkbox label="A" name="type" />
        <el-checkbox label="B" name="type" />
        <el-checkbox label="C" name="type" />
        <el-checkbox label="D" name="type" />
      </el-checkbox-group>
    </el-form-item>
    <el-form-item label="Radio check">
      <el-radio-group v-model="form.resource">
        <el-radio label="A" />
        <el-radio label="B" />
      </el-radio-group>
    </el-form-item>
    <el-form-item label="Activity form">
      <el-input v-model="form.desc" type="textarea" />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="onSubmit">Filtrar</el-button>
      <el-button>Crear</el-button>
      <el-button>Exportar a Excel</el-button>
    </el-form-item>
  </el-form>
</template>