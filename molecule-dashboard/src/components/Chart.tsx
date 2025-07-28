import { Bar } from 'react-chartjs-2';
import { useSelector } from 'react-redux';
import type { RootState } from '../app/store';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

export const Chart = () => {
  const molecules = useSelector((state: RootState) => state.molecules.molecules);

  const data = {
    labels: molecules.map(m => m.name),
    datasets: [
      {
        label: 'Poids moléculaire',
        data: molecules.map(m => m.weight),
        backgroundColor: 'rgba(75,192,192,0.6)',
      },
    ],
  };

  return <Bar data={data} />;
};