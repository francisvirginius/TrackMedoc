import { configureStore } from '@reduxjs/toolkit';
import moleculeReducer from '../features/molecules/moleculeSlice';

export const store = configureStore({
  reducer: {
    molecules: moleculeReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;