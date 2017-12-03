import conversionPreferenceStore from '../data/ConversionPreferences';

declare global {
  interface Window {
    webkit: any;
    dragEvent(url: String): void;
    resolvePromise(promiseId: number, data: any, error: any): any;
  }
}

let promiseCount = 0;
const promises = {};

const onDrag = (() => {
  const callOnDrag: Array<Function> = [];
  return {
    addToCall: (func: Function) => callOnDrag.push(func),
    call: () => callOnDrag.forEach((func) => func.call(null)),
  };
})();

window.dragEvent = function (uri: string) {
  conversionPreferenceStore.set({key: 'uri', value: uri});
  onDrag.call();
};

window.resolvePromise = function(promiseId: number, data:any, error) {
  if (error) {
    return promises[promiseId].reject(data);
  }
  promises[promiseId].resolve(data);
  promises[promiseId] = null;
  delete promises[promiseId];
};

// window.addVersion = (version: string) => console.log(version);

const swift = (swiftFunction: string, namedArguments:any = {}): Promise<string> => {
  var promise = new Promise<string>((resolve, reject) => {
    promiseCount++;
    promises[promiseCount] = { resolve, reject };
    try {
      window.webkit.messageHandlers.callbackHandler.postMessage(
        Object.assign(
          {
            promiseId: promiseCount,
            functionToRun: swiftFunction
          },
          namedArguments
        )
      );
    } catch (error) {
      console.log(error);
    }
  });
  return promise;
};

function doConversion(args: any): Promise<string> {
  return swift('beginConversion', args);
}

function getCurrentVersion(): Promise<string> {
  return swift('getCurrentVersion');
}

export { getCurrentVersion };
export { doConversion };
export { onDrag };
