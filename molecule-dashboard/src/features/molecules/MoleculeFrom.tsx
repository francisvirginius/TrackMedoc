import { useState } from 'react';
import { useDispatch } from 'react-redux';
import { addMolecule } from './moleculeSlice';
import { v4 as uuidv4 } from 'uuid';

export const MoleculeForm = () => {
  const [name, setName] = useState('');
  const [weight, setWeight] = useState<number>(0);
  const [type, setType] = useState('');
  const dispatch = useDispatch();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    dispatch(
      addMolecule({ id: uuidv4(), name, weight, type })
    );
    setName('');
    setWeight(0);
    setType('');
  };

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-2">
      <input placeholder="Nom" value={name} onChange={(e) => setName(e.target.value)} className="border p-2" />
      <input placeholder="Poids" type="number" value={weight} onChange={(e) => setWeight(+e.target.value)} className="border p-2" />
      <input placeholder="Type" value={type} onChange={(e) => setType(e.target.value)} className="border p-2" />
      <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Ajouter</button>
    </form>
  );
};