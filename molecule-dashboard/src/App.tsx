import { Provider } from 'react-redux';
import { store } from './app/store';
import { Dashboard } from './Pages/Dashboard';

const App = () => {
  return (
    <Provider store={store}>
      <Dashboard />
    </Provider>
  );
};

export default App;