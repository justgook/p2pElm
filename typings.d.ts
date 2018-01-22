declare module "*.json" {
  const value: any;
  export default value;
}

declare module '*.elm' {


  type IElmRuntimeValue = { fullscreen?: any, worker?: any, [x: string]: IElmRuntimeValue };

  interface IElmRuntime {
    [x: string]: IElmRuntimeValue;
  }
  const elmRuntime: IElmRuntime;
  export = elmRuntime;
}