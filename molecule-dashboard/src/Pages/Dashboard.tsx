import { MoleculeForm } from '../features/molecules/MoleculeFrom';
import { Chart } from '../components/Chart';

export const Dashboard = () => {
  return (
    <div className="p-4 grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <h2 className="text-xl font-bold mb-2">Ajouter une molécule</h2>
        <MoleculeForm />
      </div>
      <div>
        <h2 className="text-xl font-bold mb-2">Graphique</h2>
        <Chart />
      </div>
    </div>
  );
};