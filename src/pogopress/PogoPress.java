package pogopress;

/* -*- mode: java; c-basic-offset: 2; indent-tabs-mode: nil -*- */

/*
  PSerial - class for serial port goodness
  Part of the Processing project - http://processing.org

  Copyright (c) 2004-05 Ben Fry & Casey Reas

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General
  Public License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place, Suite 330,
  Boston, MA  02111-1307  USA
*/

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

public class PogoPress{

//**********************POGO**************************
	public  Boolean show7eStart = false;
	public  Boolean show7eStop = false;
	public  Boolean show45 = false;
	public  Boolean isStart = false;
	public  List<Integer> pktData = new ArrayList<Integer>();
	public  List<Integer> ids = new ArrayList<Integer>();
//**********************POGO**************************
	
  PApplet parent;

  public PogoPress(PApplet parent, List<Integer> ids) {
	  this.parent = parent;
	  this.ids = ids;
  }
//**********************POGO**************************
  public int[] getPogoData(int readdata) {
	int[] result= new int[2];
	result = processPacket(readdata);
	return result;
  }
//**********************POGO**************************

//**********************POGO**************************
	private int[] processPacket(int readPacket) {
		//System.out.print(Integer.toHexString(readPacket)+" ");
		int[] result = new int[2];
		pktData.add(readPacket);
		if (readPacket == 126) {// 7e
			//System.out.print("7e show!");

			if (show7eStart == false) {
				show7eStart = true;
				//System.out.print("Start!");
				pktData.removeAll(pktData);
				pktData.add(readPacket);
			} else if (show7eStart == true) {
				show7eStop = true;
				//System.out.print("Stop!");
			}

			if (show7eStart && show7eStop && show45) {
				int pktSize = pktData.size();
				if (pktSize == 39) {
					//System.out.print("\n-->Normal data...");
					result = processData(pktData); 
				} else {
					System.out.println("-------------->Odd pkt size=" + pktSize);
				}
				pktData.removeAll(pktData);
				show7eStart = false;
				show7eStop = false;
				show45 = false;
			}
		}// 7e show
		else if (readPacket == 69) {// 45
			// println("7e show!");
			if (show7eStart == true) {
				show45 = true;
			}
		}
		return result;
	}
//**********************POGO**************************
	
//**********************POGO**************************
	private int[] processData(List<Integer> pktData) {
		int[] result = new int[2];
		result[0] = 0;
		result[1] = 0;
		Integer id = pktData.get(4);
		// print("id="+id);
		Integer[] r = new Integer[50];
		for (int i = 0; i < 25; i++) {
			// print("("+pktData.get(i+11)+")");
			r[i * 2 + 1] = pktData.get(i + 11) % 16;
			r[i * 2] = (pktData.get(i + 11) - r[i * 2 + 1]) / 16;
			// print(r[i*2]+" "+r[i*2+1]+" ");
		}
		Integer[] diff = new Integer[10];
		for (int i = 0; i < 10; i++) {
			diff[i] = 0;
			for (int j = 0; j < 4; j++) {
				diff[i] += Math.abs(r[(j + 1) * 10 + i] - r[j * 10 + i]);
			}
			if (diff[i] > 0) {
				System.out.println("id=" + id + "No." + Integer.toString(i) + " Press");
				// call the function which you should finish
				for (int k = 0; k < ids.size(); k++) {
					if (id == ids.get(k)){
						result[0] = id;
						result[1] = i;
					}
				}
			}
		}
		return result;
	}
//**********************POGO**************************
}
