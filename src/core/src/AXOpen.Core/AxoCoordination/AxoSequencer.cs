// AXOpen.Core
// Copyright (c)2022 MTS spol. s r.o. and Contributors All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

using System;
using System.Linq;
using System.Threading.Channels;
using System.Threading.Tasks;
using AXSharp.Connector;

namespace AXOpen.Core;

public partial class AxoSequencer
{
    partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
    {
        this.CollectDataTask.InitializeExclusively(CollectSequenceData);
    }

    public async Task CollectSequenceData()
    {
        try
        {
            Console.WriteLine($"--------------------------------------------------------------------------\n");
            var steps = this.GetChildren().Where(p => p is AxoStep).Select(p => (p as AxoStep).Analytics);

            var ordered = this.GetChildren().Where(p => p is AxoStep).Select(p => (p as AxoStep).Analytics.Order);

            
            await this.Connector.ReadBatchAsync(ordered);
            var activeSteps = steps.Where(p => p.Order.LastValue > 0);
                

            await this.Connector.ReadBatchAsync(activeSteps.SelectMany(p => p.GetValueTags()));
            foreach (var step in activeSteps.OrderBy(p => p.Order.LastValue))
            {
                
                Console.WriteLine($"{step.Order.LastValue} : {step.Description.LastValue} : {step.Duration.LastValue}");
            }
        }
        catch (Exception e)
        {
            throw; // TODO handle exception
        }
    }
}