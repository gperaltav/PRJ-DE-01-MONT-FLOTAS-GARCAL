<script  setup>
import axios from 'axios'
import '../assets/sketch.min.js'

</script>

<script >
  export default {
    name: 'Login',

    data() {
      return {
        input: {
          username: "",
          password: ""
        },
      }
    },

    methods: {
      login() {
        //console.log(this.$store.state.authenticated);
        if(this.input.username != "" && this.input.password != "") {
          if(this.input.username ==  this.$store.state.Account.username && this.input.password == this.$store.state.Account.password) {
            this.$store.dispatch('authenticate');
          }
          else {
            alert ("Contraseña incorrecta, intente nuevamente");  
            console.log("Usuario o contraseña incorrectos");
          }
        } else {
          alert ("Campos vacios");  
          console.log("Se debe ingresar una contraseña");
        }
      },
      animation() {
        var Mountain, MountainRange, dt, mountainRanges, sketch;
        sketch = Sketch.create({
          container: document.getElementById( 'sketch-area' ),
        });
        sketch.mouse.x = sketch.width / 10;
        sketch.mouse.y = sketch.height;
        mountainRanges = [];
        dt = 1;
        Mountain = function(config) {
          return this.reset(config);
        };
        Mountain.prototype.reset = function(config) {
          this.layer = config.layer;
          this.x = config.x;
          this.y = config.y;
          this.width = config.width;
          this.height = config.height;
          return this.color = config.color;
        };
        MountainRange = function(config) {
          this.x = 0;
          this.mountains = [];
          this.layer = config.layer;
          this.width = {
            min: config.width.min,
            max: config.width.max
          };
          this.height = {
            min: config.height.min,
            max: config.height.max
          };
          this.speed = config.speed;
          this.color = config.color;
          this.populate();
          return this;
        };
        MountainRange.prototype.populate = function() {
          var newHeight, newWidth, totalWidth, _results;
          totalWidth = 0;
          _results = [];
          while (totalWidth <= sketch.width + (this.width.max * 4)) {
            newWidth = round(random(this.width.min, this.width.max));
            newHeight = round(random(this.height.min, this.height.max));
            this.mountains.push(new Mountain({
              layer: this.layer,
              x: this.mountains.length === 0 ? 0 : this.mountains[this.mountains.length - 1].x + this.mountains[this.mountains.length - 1].width,
              y: sketch.height - newHeight,
              width: newWidth,
              height: newHeight,
              color: this.color
            }));
            _results.push(totalWidth += newWidth);
          }
          return _results;
        };
        MountainRange.prototype.update = function() {
          var firstMountain, lastMountain, newHeight, newWidth;
          this.x -= (sketch.mouse.x * this.speed) * dt;
          firstMountain = this.mountains[0];
          if (firstMountain.width + firstMountain.x + this.x < -this.width.max) {
            newWidth = round(random(this.width.min, this.width.max));
            newHeight = round(random(this.height.min, this.height.max));
            lastMountain = this.mountains[this.mountains.length - 1];
            firstMountain.reset({
              layer: this.layer,
              x: lastMountain.x + lastMountain.width,
              y: sketch.height - newHeight,
              width: newWidth,
              height: newHeight,
              color: this.color
            });
            return this.mountains.push(this.mountains.shift());
          }
        };
        MountainRange.prototype.render = function() {
          var c, d, i, pointCount, _i, _ref;
          sketch.save();
          sketch.translate(this.x, (sketch.height - sketch.mouse.y) / 20 * this.layer);
          sketch.beginPath();
          pointCount = this.mountains.length;
          sketch.moveTo(this.mountains[0].x, this.mountains[0].y);
          for (i = _i = 0, _ref = pointCount - 2; _i <= _ref; i = _i += 1) {
            c = (this.mountains[i].x + this.mountains[i + 1].x) / 2;
            d = (this.mountains[i].y + this.mountains[i + 1].y) / 2;
            sketch.quadraticCurveTo(this.mountains[i].x, this.mountains[i].y, c, d);
          }
          sketch.lineTo(sketch.width - this.x, sketch.height);
          sketch.lineTo(0 - this.x, sketch.height);
          sketch.closePath();
          sketch.fillStyle = this.color;
          sketch.fill();
          return sketch.restore();
        };
        sketch.setup = function() {
          var i, _results;
          i = 5;
          _results = [];
          while (i--) {
            _results.push(mountainRanges.push(new MountainRange({
              layer: i + 1,
              width: {
                min: (i + 1) * 70,
                max: (i + 1) * 90
              },
              height: {
                min: 250 - (i * 30),
                max: 350 - (i * 30)
              },
              speed: (i + 1) * .003,
              color: 'hsl( 206, ' + (((i + 1) * 1) + 10) + '%, ' + (50 + (i * 13)) + '% )'
            })));
          }
          return _results;
        };
        sketch.clear = function() {
          return sketch.clearRect(0, 0, sketch.width, sketch.height);
        };
        sketch.update = function() {
          var i, _results;
          dt = sketch.dt < .1 ? .1 : sketch.dt / 16;
          dt = dt > 5 ? 5 : dt;
          i = mountainRanges.length;
          _results = [];
          while (i--) {
            _results.push(mountainRanges[i].update(i));
          }
          return _results;
        };
        sketch.draw = function() {
          var i, _results;
          i = mountainRanges.length;
          _results = [];
          while (i--) {
            _results.push(mountainRanges[i].render(i));
          }
          return _results;
        };

      },
      login_api() {
        axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/comprobar', 
          { 
            "usu_codigo": String(this.input.username),
            "usu_clave": String(this.input.password)
          })
          .then((resp) => {
            console.log(resp);  
            var logg=resp.data[0].usu_existe;
            if(logg) {
              console.log("Logeado");
              this.$store.dispatch('authenticate');
              this.$store.commit('set_user', {
                username: resp.data[0].usu_codigo
              });
            }
            else {
              console.log("No Logeado");
              console.log("Usuario o contraseña incorrectos");
            }
          })
          .catch((e)=> {
            console.log(e);
            console.log("Error interno al in8iciar sesión");
          })
      },
      
    },
    mounted () {
      this.animation();
    },
  }
  
</script>


<template>
  <el-container class="layout-container" style="height: calc( 100vh - 20px );">
    <el-container>

      <el-header style="text-align: left; font-size: 24px">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-header>
      
      <el-main  style="background-color:white">
        <div  id="sketch-area"></div>
        <div  class="login-page">
          
          <div  class="logsection">
          <p> Iniciar sesión </p>
          <div class="form">
            <form @submit.prevent class="login-form">
              <input type="text" v-model="input.username" placeholder="Nombre de usuario"/>
              <input type="password" v-model="input.password" placeholder="Contraseña"/>
              <button v-on:click="login_api()">Entrar</button>
            </form>
          </div>
          </div>
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
  .layout-container .el-header {
    position: relative;
    background-color: rgb(8, 68, 164);
    color: rgb(240, 240, 240);
    text-align: left;
    font-family: "Roboto", sans-serif;
  }
  .layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}
  #login {
    width: 500px;
    border: 1px solid #ffffff;
    background-color: #f0f0f0;
    margin: auto;
    margin-top: 200px;
    padding: 20px;
  }
  canvas {
    background: 
      linear-gradient(
        hsl(200, 50%, 80%) 0%, 
        hsl(200, 30%, 95%) 75%)
    ;
    display: block;
  }

  .back {
    background: url(https://jackrugile.com/images/misc/skyline-texture.png);
    height: 100%;
    left: 0;
    position: fixed;
    top: 0;
    width: 100%;
}

.login-page {
  width: 360px;
  padding: 8% 0 0;
  margin: auto;
  
}
.logsection {
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}
.login-page p {
  
  font-family: "Roboto", sans-serif;
  position: relative;
  z-index: 1;
  background: #d4d4d4;
  max-width: 360px;
  margin: 0;
  padding: 15px;
  text-align: center;
  
}
.form {
  position: relative;
  z-index: 1;
  background: #FFFFFF;
  max-width: 360px;
  margin: 0 auto 100px;
  padding: 45px;
  text-align: center;
}
.form input {
  font-family: "Roboto", sans-serif;
  outline: 0;
  background: #f2f2f2;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}
.form button {
  font-family: "Roboto", sans-serif;
  text-transform: uppercase;
  outline: 0;
  background: #dadada;
  width: 100%;
  border: 0;
  padding: 15px;
  color: #252525;
  font-size: 14px;
  -webkit-transition: all 0.3 ease;
  transition: all 0.3 ease;
  cursor: pointer;
  margin-top: 20px;
}
.form button:hover,.form button:active,.form button:focus {
  background: #325ea0;
}
.form .message {
  margin: 15px 0 0;
  color: #b3b3b3;
  font-size: 12px;
}
.form .message a {
  color: #4CAF50;
  text-decoration: none;
}
.form .register-form {
  display: none;
}
.container {
  position: relative;
  z-index: 1;
  max-width: 300px;
  margin: 0 auto;
}

#sketch-area {
  background: url(https://jackrugile.com/images/misc/skyline-texture.png);
  position: absolute;
}
</style>