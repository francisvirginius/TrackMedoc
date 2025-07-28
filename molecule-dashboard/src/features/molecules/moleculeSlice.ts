import { createSlice } from '@reduxjs/toolkit';
import type { PayloadAction } from '@reduxjs/toolkit';

export interface Molecule {
  id: string;
  name: string;
  weight: number;
  type: string;
}

interface MoleculeState {
  molecules: Molecule[];
}

const initialState: MoleculeState = {
  molecules: [],
};

const moleculeSlice = createSlice({
  name: 'molecules',
  initialState,
  reducers: {
    addMolecule: (state, action: PayloadAction<Molecule>) => {
      state.molecules.push(action.payload);
    },
    removeMolecule: (state, action: PayloadAction<string>) => {
      state.molecules = state.molecules.filter(m => m.id !== action.payload);
    },
    updateMolecule: (state, action: PayloadAction<Molecule>) => {
      const index = state.molecules.findIndex(m => m.id === action.payload.id);
      if (index !== -1) {
        state.molecules[index] = action.payload;
      }
    },
  },
});

export const { addMolecule, removeMolecule, updateMolecule } = moleculeSlice.actions;
export default moleculeSlice.reducer;
