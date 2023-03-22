#!/usr/bin/env python3.6

import asyncio
from spade.agent import Agent
from spade.behaviour import CyclicBehaviour
from spade.message import Message


class SenderAgent(Agent):

    class SenderBehaviour(CyclicBehaviour):

        async def run(self):
            receiver_jid = "receiver@localhost"
            msg = Message(to=receiver_jid)
            msg.body = "Hello World!"
            await self.send(msg)
            print(f"Sent message to {receiver_jid}")
            await asyncio.sleep(1)

    async def setup(self):
        print("SenderAgent is starting up")
        b = self.SenderBehaviour()
        self.add_behaviour(b)


class ReceiverAgent(Agent):

    class ReceiverBehaviour(CyclicBehaviour):

        async def run(self):
            msg = await self.receive(timeout=10)
            if msg:
                print(f"Received message from {msg.sender}: {msg.body}")
            else:
                print("Timeout reached, stopping...")
                self.kill()

    async def setup(self):
        print("ReceiverAgent is starting up")
        b = self.ReceiverBehaviour()
        self.add_behaviour(b)


if __name__ == "__main__":
    # Start the receiver agent
    receiver_agent = ReceiverAgent("receiver@localhost", "mypassword")
    receiver_agent.start()

    # Start the sender agent
    sender_agent = SenderAgent("sender@localhost", "mypassword")
    sender_agent.start()
