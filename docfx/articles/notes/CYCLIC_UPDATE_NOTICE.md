> [!IMPORTANT]
> This component requires cyclic data updates, which are typically sourced from the I/O system. Before using the component, make sure you invoke the `Run` method. Additionally, it's crucial to ensure that the `Run` method is positioned within a call tree that operates cyclically. Failing to initiate the `Run` method or not guaranteeing its cyclic execution can lead to malfunctions and unpredictable component behavior. In extreme circumstances, this could cause erratic controller behavior, potentially leading to equipment damage.

