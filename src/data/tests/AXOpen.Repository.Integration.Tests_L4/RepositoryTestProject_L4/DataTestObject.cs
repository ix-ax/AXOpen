using AXOpen.Base.Data;
using AXSharp.Connector;
using Pocos.plc1;

namespace RepositoryTestProject_L4
{
    public class DataTestObject : tCu010_Data, IBrowsableDataObject
    {
        public DataTestObject()
        {
            _Created = DateTime.Now;
        }

        public string DataEntityId { get; set; }
        public object RecordId { get; set; }
        public DateTime _Created { get; set; }

        #region DataInitialization

        public void FillUpData(int iteration, DateTime initialTime)
        {
            DataEntityId = iteration.ToString();

            _EntityId = DataEntityId;

            _Created = initialTime.AddMinutes(iteration * 1);

            Screw_1.Prog = (short)(10 + iteration);
            Screw_2.Prog = (short)(20 + iteration);

            SetFlow(Flow, iteration, _Created);
            SetScrew(Screw_1, iteration, _Created);
            SetScrew(Screw_2, iteration, _Created);
        }

        private static void SetFlow(tHeaderCu unit, int iteration, DateTime created)
        {
            unit.CycleTime = TimeSpan.FromSeconds(iteration * 1 + iteration * 0.2);
            unit.CleanLoopTime = TimeSpan.FromSeconds(iteration * 1);

            unit.NextOnPassed = (ushort)(iteration + 1);
            unit.NextOnFailed = (ushort)(iteration + 20);

            unit.OperationsStarted = created.AddSeconds(iteration);
            unit.OperationsEnded = created.AddSeconds(iteration * 0.2 + 1);

            unit.Operator = "Operator_" + ((int)(iteration * 0.5)).ToString();
        }

        private static void SetScrew(tScrew s, int iteration, DateTime started)
        {
            s.Result.TimeStamp = started + TimeSpan.FromMicroseconds(200);
            s.Torque.TimeStamp = started + TimeSpan.FromMicroseconds(400);

            s.Result.Result = 20;
            s.Torque.Result = 20;

            s.Result.PassedTime = TimeSpan.FromMicroseconds(10);
            s.Result.FailedTime = TimeSpan.FromMicroseconds(100);

            s.Torque.PassedTime = TimeSpan.FromMicroseconds(10);
            s.Torque.FailedTime = TimeSpan.FromMicroseconds(100);
             

        }

        #endregion DataInitialization
    }
}