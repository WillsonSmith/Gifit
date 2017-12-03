import * as React from 'react';
import './App.css';
import conversionPreferenceStore from './data/ConversionPreferences';

import { onDrag, doConversion, getCurrentVersion } from './swift_specifics/globals';

class App extends React.Component {

  state = {
    version: '',
    fps: 25,
    scale: 500,
    loading: false,
  };

  constructor(props: any) {
    super(props);
    conversionPreferenceStore.set({ key: 'fps', value: this.state.fps} );
    conversionPreferenceStore.set({ key: 'scale', value: this.state.scale} );
    onDrag.addToCall(this.convert);
  }

  componentWillMount() {
    this.version();
  }

  async version() {
    this.setState({
      version: await getCurrentVersion(),
    });
  }

  convert = async () => {
    this.setState({loading: true});
    const returned = await doConversion(conversionPreferenceStore.get());
    this.setState({loading: false});
    console.log(returned);
  }

  updatePreference = (evt: any) => {
    const element = evt.target;
    const key = element.name;
    const value = Number(element.value);

    conversionPreferenceStore.set({key, value});
    if (key === 'fps') { this.setState({fps: value}); }
    if (key === 'scale') { this.setState({scale: value}); }
  }

  loadingElement() {
    if (!this.state.loading) { return; }
    return <p>Loading...</p>;
  }

  render() {
    return (
      <div className="App">
        <div className="PreferenceWrapper">
          <div className="PreferenceInputs">
            <label>
              <div>Framerate</div>
              <input
                name="fps"
                type="text"
                value={this.state.fps}
                onChange={this.updatePreference} 
              />
            </label>

            <label>
              <div>Scale</div>
              <input
                name="scale"
                type="text"
                value={this.state.scale}
                onChange={this.updatePreference}
              />
            </label>
          </div>
        </div>
        <div className="DropZone">
          {this.loadingElement()}
          <p className="DropText">Drag and drop video</p>
        </div>
      </div>
    );
  }
}

export default App;
