import { Controller } from "@hotwired/stimulus"
import * as THREE from 'three'
import { GLTFLoader } from "https://cdn.jsdelivr.net/npm/three@0.162.0/examples/jsm/loaders/GLTFLoader.js"
import { OrbitControls } from "https://cdn.jsdelivr.net/npm/three@0.162.0/examples/jsm/controls/OrbitControls.js"

// Connects to data-controller="removals"
export default class extends Controller {
  scene;
  camera;
  renderer;
  cube;
  loader;

  connect() {
    console.log("---- three ----")

    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color('#263238');
    // this.scene.background = new THREE.Color('#f0f2f5');

    //创建一个平行光
    const directionalLight = new THREE.DirectionalLight(0xffffff, 2);
    directionalLight.position.set(0, 1, 0); // 设置光源位置，[0,1,0]从上到下
    this.scene.add(directionalLight);

    // 创建一个环境光
    const ambientLight = new THREE.AmbientLight(0xffffff); // 设置光照颜色
    ambientLight.intensity = 2; // 增加环境光的强度
    this.scene.add(ambientLight);
    
    // this.camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 1000);
    this.camera = new THREE.PerspectiveCamera(50, 700 / 700, 0.1, 1000);
    this.renderer = new THREE.WebGLRenderer();
    // this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.renderer.setSize(700, 500);

    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true; // 鼠标平滑控制旋转
    this.controls.update();
    
    document.getElementById("three").appendChild(this.renderer.domElement);
    // const geometry = new THREE.BoxGeometry(1, 1, 1);
    // const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
    // this.cube = new THREE.Mesh(geometry, material);
    // this.scene.add(this.cube);
    this.camera.position.z = 5;
    // ...................
    // 设置父级 div 的尺寸
    const parentDiv = document.getElementById("three");
    // const width = parentDiv.Width;
    // const height = parentDiv.Height;

    // this.renderer.setSize(width, height);

    // this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    // this.controls.enableDamping = true;
    // this.controls.update();

    // parentDiv.appendChild(this.renderer.domElement);

    // // this.camera.position.z = 5;

    window.addEventListener('resize', () => {
        // 更新相机和渲染器的大小
        const width = parentDiv.clientWidth;
        const height = parentDiv.clientHeight;
        
        this.camera.aspect = width / height;
        this.camera.updateProjectionMatrix();
        this.renderer.setSize(width, height);
    });
    // ...................
    this.animate();

    this.loader = new GLTFLoader();
    const imagePath = '/three/eiffel.glb';
    // const url = new URL(imagePath, window.location.origin).toString();
    this.loader.load(imagePath, (gltf) => {
      console.log('... loader ...');

      this.scene.add(gltf.scene);
    }, undefined, (error) => {
      console.error(error);
    });
  }

  animate = () => {
    requestAnimationFrame(this.animate);
    // this.cube.rotation.x += 0.01;
    // this.cube.rotation.y += 0.01;
    this.renderer.render(this.scene, this.camera);
    this.controls.update();
  };
  
}

